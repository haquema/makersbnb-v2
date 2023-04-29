require_relative 'booking'

class BookingRepository
  def all
    sql = 'SELECT id, property_id, user_id, start_date, end_date, status FROM bookings;'
    result_set = DatabaseConnection.exec_params(sql, [])

    bookings = []

    result_set.each do |record|
      booking = Booking.new
      record_to_object(booking, record)
      bookings << booking
    end

    return bookings 
  end

  def find(id)
    sql = 'SELECT id, property_id, user_id, start_date, end_date, status FROM bookings WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    booking = Booking.new
    result_set.each do |record|
      booking = Booking.new
      record_to_object(booking, record)
      bookings << booking
    end

    return booking
  end  
              
  def create(booking)
    sql = 'INSERT INTO bookings (property_id, user_id, start_date, end_date, status) VALUES ($1, $2, $3, $4, $5);'
    params = [booking.property_id, booking.user_id, booking.start_date, booking.end_date, booking.status]
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

  def record_to_object(object, record)
    record.each do |key, value|
      object.key = value
    end
  end
end
