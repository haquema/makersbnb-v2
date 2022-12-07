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

=begin

  def create(user)

    sql = 'INSERT into users (username, email_address, password) VALUES ($1, $2, $3)'
    params = [user.username, user.email_address, user.password]
    DatabaseConnection.exec_params(sql, params)
  end
=end
end
