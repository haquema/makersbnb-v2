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
    params = [booking.property_id, booking.booker_id, booking.start_date, booking.end_date, 'pending']
    DatabaseConnection.exec_params(sql, params)
    
    # sql = 'INSERT INTO property_dates (property_id, unavailable_dates, status) VALUES ($1, $2, $3);'
    # params = [booking.property_id, date_string_builder(booking.start_date, booking.end_date), booking.status]
    # DatabaseConnection.exec_params(sql, params)
  end

  def confirm(id)
    sql = 'UPDATE bookings SET status = $1 WHERE id = $2'
    booking = BookingRepository.find(id)
    params = ['confirmed', id]
    DatabaseConnection.exec_params(sql, params)

    sql = 'INSERT INTO property_dates (property_id, booking_id, unavailable_dates) VALUES ($1, $2, $3);'
    params = [booking.property_id, id, date_string_builder(booking.start_date, booking.end_date)]
    DatabaseConnection.exec_params(sql, params)
  end

  def cancel(id)
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

  def date_string_builder(start_date, end_date)
    start_day, start_month = start_date[-2,2].to_i, start_date[-5,2].to_i
    end_day, end_month = end_date[-2,2].to_i, end_date[-5,2].to_i
    
    month_days = { 1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31 }
    
    if start_month == end_month 
      num_days = end_day - start_day
    else 
      num_days = month_days[start_month] - start_day + end_day
    end
    return string = "#{start_date}+#{num_days}"
  end

end
