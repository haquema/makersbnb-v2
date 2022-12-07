require_relative 'booking'

class BookingRepository
  def all
    sql = 'SELECT id, requested_dates, property_id, owner_id, user_id FROM bookings;'
    result_set = DatabaseConnection.exec_params(sql, [])

    bookings = []

    result_set.each do |record|
      booking = Booking.new
      booking.id = record['id']
      booking.requested_dates = record['requested_dates']
      booking.property_id = record['property_id']
      booking.owner_id = record['owner_id']
      booking.user_id = record['user_id']

      bookings << booking
    end

    return bookings 
  end

  def find(id)
    sql = 'SELECT id, requested_dates, property_id, owner_id user_id FROM bookings WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    booking = Booking.new
    booking.id = result_set[0]['id'].to_i
    booking.requested_dates = result_set[0]['requested_dates']
    booking.property_id = result_set[0]['property_id'].to_i
    booking.owner_id = result_set[0]['owner_id'].to_i
    booking.user_id = result_set[0]['user_id'].to_i

    return booking
  end  
              
  def create(booking)
    sql = 'INSERT INTO bookings (requested_dates, property_id, owner_id, user_id) VALUES ($1, $2, $3, $4);'
    params = [booking.requested_dates, booking.property_id, booking.owner_id, booking.user_id]
    DatabaseConnection.exec_params(sql, params)
  end
end
