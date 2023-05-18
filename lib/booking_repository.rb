require_relative 'booking'
require_relative 'property'
require_relative 'property_repository'
require 'date'



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
  
  def find_by_booker(booker_id)
    sql = 'SELECT id, property_id, booker_id, start_date, end_date, status FROM bookings WHERE booker_id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [booker_id])

    bookings= []
    result_set.each do |result|
      booking = Booking.new
      booking_object_mapping(booking, result)
      bookings << booking
    end

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

  def confirm(booking)
    sql = 'UPDATE bookings SET status = $1 WHERE id = $2'
    params = ['confirmed', booking.id]
    DatabaseConnection.exec_params(sql, params)

    sql = 'INSERT INTO property_dates (property_id, booking_id, unavailable_dates) VALUES ($1, $2, $3);'
    params = [booking.property_id, booking.id, date_string_builder(booking.start_date, booking.end_date)]
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
    date_start = string_to_date(start_date)
    date_end = string_to_date(end_date)

    string_to_return = ''
    while date_start <= date_end
      string_to_return += date_start.to_s + " "
      date_start += 1
    end
    return string_to_return.strip()
  end

  def string_to_date(date_string)
    arr = date_string.split("-").map {|x| x.to_i}
    return Date.new(arr[0], arr[1], arr[2])
  end

end
