require_relative './property'
require_relative 'database_connection'

class PropertyRepository
  def all
    result_set = DatabaseConnection.exec_params('SELECT id, property_name, property_description, price_per_night FROM properties;', [])
    
    properties = []

    result_set.each do |record|
      property = Property.new
      property.id = record['id']
      property.property_name = record['property_name']
      property.property_description = record['property_description']
      property.price_per_night = record['price_per_night']

      properties << property
    end

    return properties
  end

  def create(property)
  
    sql = 'INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ($1, $2, $3, $4)'
    params = [property.property_name, property.property_description, property.price_per_night, property.owner_id]
    DatabaseConnection.exec_params(sql, params)
  end
end