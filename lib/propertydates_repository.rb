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

  def find_by_property(property_id)
    sql = 'SELECT id, booking_id, unavailable_dates FROM property_dates WHERE property_id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [property_id])[0]
    
    records = []

    result_set.each do |record|
      record = PropertyDate.new
      record.id = result_object["id"]
      record.booking_id = result_object['booking_id']
      record.property_id = property_id
      record.unavailable_dates = result_object['unavailable_dates']
      records << record
    end
    
    return records
  end
  
end