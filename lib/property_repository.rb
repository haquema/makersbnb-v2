require_relative './property'
require_relative 'database_connection'

class PropertyRepository
  def all
    sql = 'SELECT id, name, description, price, to_rent, user_id FROM properties'
    params = []
    result_set = DatabaseConnection.exec_params(sql, params)
    
    properties = []

    result_set.each do |record|
      property = Property.new
      property_object_mapping(property, record)
      properties << property
    end

    return properties
  end

  def create(property)
    sql = 'INSERT INTO properties (name, description, price, to_rent, user_id) VALUES $1, $2 $3 $4 $5'
    params = [property.name, property.description, property.price, property.user_id]
    DatabaseConnection.exec_params(sql, params)
  end

  def update(property)
    sql = 'UPDATE properties SET name = $1, description = $2, price = $3, to_rent = $4'
    params = [property.name, property.description, property.price, property.to_rent]
    DatabaseConnection.exec_params(sql, params)
  end

  # will need to check that deleting property will delete related bookings
  def delete(id)
    sql = 'DELETE FROM properties WHERE id = $1'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end
  
  private

  def property_object_mapping(object, record)
    object.id = record['id']
    object.name = record['name']
    object.description = record['description']
    object.price = record['price']
    object.to_rent = record['to_rent']
    object.user_id = record['user_id']
  end
end