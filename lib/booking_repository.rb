require_relative 'booking'
require_relative 'property'
require_relative 'property_repository'



class BookingRepository
  def all
    sql = 'SELECT id, property_id, booker_id, start_date, end_date, status FROM bookings;'
    result_set = DatabaseConnection.exec_params(sql, [])

    bookings = []

    result_set.each do |record|
      booking = Booking.new
      booking_object_mapping(booking, record)
      bookings << booking
    end

    return bookings 
  end

  def find(id)
    sql = 'SELECT id, property_id, booker_id, start_date, end_date, status FROM bookings WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    booking = Booking.new
    booking_object_mapping(booking, result_set[0])

    return booking
  end  
              
  def create(booking)
    sql = 'INSERT INTO bookings (property_id, booker_id, start_date, end_date, status) VALUES ($1, $2, $3, $4, $5);'
    params = [booking.property_id, booking.booker_id, booking.start_date, booking.end_date, booking.status]
    DatabaseConnection.exec_params(sql, params)
    
    sql = 'UPDATE properties SET date_unavailable = $1 WHERE id = $2;'
    property = PropertyRepository.new.find_by_id(booking.property_id)
    date_unavailable_strings = property.date_unavailable.split(' ')
    date_unavailable_strings.append(booking.start_date + booking.end_date)
    updated_date_unavailable = date_unavailable_strings.join(' ')
    params = [updated_date_unavailable, property.id]
    DatabaseConnection.exec_params(sql, params)
  end

  def update(original, updated)
    sql = 'UPDATE bookings SET start_date = $1, end_date = $2, status = $3 WHERE id = $4'
    params = [updated.start_date, updated.end_date, updated.status, original.id]
    DatabaseConnection.exec_params(sql, params)

    sql = 'UPDATE properties SET date_unavailable = $1 WHERE id = $2;'
    property = PropertyRepository.new.find_by_id(original.property_id)
    string_array = property.date_unavailable.split(' ')
    string_array.delete(original.start_date+original.end_date)
    string_array.append(updated.start_date+updated.end_date)
    updated_string = string_array.join(' ')
    params = [updated_string, property.id]
    DatabaseConnection.exec_params(sql, params)
  end

  def delete(id)
    sql = 'DELETE FROM bookings WHERE id = $1'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end

  private

  def booking_object_mapping(object, record)
    object.id = record['id']
    object.property_id = record['property_id']
    object.booker_id = record['booker_id']
    object.start_date = record['start_date']
    object.end_date = record['end_date']
    object.status = record['status']
  end
end
