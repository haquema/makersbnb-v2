require_relative 'propertydate'

class PropertyDatesRepository
  def find(booking_id)
    sql = 'SELECT id, property_id, unavailable_dates FROM property_dates WHERE booking_id = $1;'
    result_object = DatabaseConnection.exec_params(sql, [booking_id])[0]

    record = PropertyDate.new
    record.id = result_object["id"]
    record.property_id = result_object['property_id']
    record.booking_id = booking_id
    record.unavailable_dates = result_object['unavailable_dates']
    return record
  end
end