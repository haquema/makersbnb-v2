require_relative 'booking'

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
  end

  def update(booking)
    sql = 'UPDATE bookings SET start_date = $1, end_date = $2, status = $3'
    params = [booking.start_date, booking.end_date, booking.status]
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
