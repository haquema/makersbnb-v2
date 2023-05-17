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
    sql = 'INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ($1, $2, $3, $4, $5)'
    params = [property.name, property.description, property.price, property.to_rent, property.user_id]
    DatabaseConnection.exec_params(sql, params)
  end

  def find_by_owner(owner_id)
    sql = 'SELECT id, name, description, price, to_rent, user_id FROM properties WHERE user_id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [owner_id])

    properties = []
    result_set.each do |record|
      property = Property.new
      property_object_mapping(property, record)
      properties << property
    end
    return properties
  end

  def find_by_id(property_id)
    sql = 'SELECT id, name, description, price, to_rent, user_id FROM properties WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [property_id])

    property = Property.new
    property_object_mapping(property, result_set[0])
    return property
  end

  def update(property)
    sql = 'UPDATE properties SET name = $1, description = $2, price = $3, to_rent = $4 WHERE id = $5;'
    params = [property.name, property.description, property.price, property.to_rent, property.id]
    DatabaseConnection.exec_params(sql, params)
  end

  # will need to check that deleting property will delete related bookings
  def delete(id)
    sql = 'DELETE FROM properties WHERE id = $1;'
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