Properties Model and Repository Classes Design Recipe

1. Design and create the Table

Table: Properties

Columns:
id | property_name | property_description | price_per_night


2. Create Test SQL seeds

-- (file: spec/seeds_properties.sql)

TRUNCATE TABLE properties RESTART IDENTITY CASCADE;

INSERT INTO properties (property_name, property_description, Price_per_night) VALUES ('Spaceship-style treehouse', 'you'll be sure to have an out of this world experience in our UFO-styled treehouse', 200, 1);
INSERT INTO properties (property_name, property_description, Price_per_night) VALUES ('Dome of the Future', 'Our beautiful camping pods are modelled on the eden project domes', 250, 1);
INSERT INTO properties (property_name, property_description, Price_per_night) VALUES ('Starship Enterprise in the Forest', 'Get the ultimate star-trek experience right in the heart of the new forest', 500, 1);

psql -h 127.0.0.1 makersbnb_test < seeds_properties.sql

3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by Repository for the Repository class name.

# EXAMPLE
# Table name: properties

# Model class
# (in lib/property.rb)
class Property
  attr_accessor :id, :property_name, :property_description, :price_per_night, :owner_id
end

# Repository class
# (in lib/property_repository.rb)
class PropertyRepository
end


4. Define the Repository Class interface

# EXAMPLE
# Table name: properties

# Repository class
# (in lib/property_repository.rb)

class BookRepository

  # Selecting all records
  # No arguments

  def all
    result_set = DatabaseConnection.exec_params('SELECT id, property_name, property_description, price_per_night FROM properties;', [])
    
    properties = []

    result_set.each do |record|
      property = record.new
      property.id = record['id']
      property.property_name = record['property_name']
      property.property_description = record['property_description']

      properties << property
    end

    return properties
  end

  def create(property)
  
    sql = 'INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ($1, $2, $3)'
    params = [property.property_name, property.property_description, property.price_per_night, property_owner_id]
    DatabaseConnection.exec_params(sql, params)

    return property
  end
end


6. Write Test Examples

# 1
# Get all students

repo = PropertyRepository.new

properties = repo.all

properties.length # =>  3


properties[0].id # =>  1
properties[0].property_name # =>  'Spaceship-style treehouse'
properties[0].property_description # =>  'you'll be sure to have an out of this world experience in our UFO-styled treehouse'
properties[0].property_price_per_night # => 200
properties[0].owner_id # => 1

properties[1].id # =>  1
properties[1].property_name # =>  'Dome of the Future'
properties[1].property_description # =>  'Our beautiful camping pods are modelled on the eden project domes'
properties[1].property_price_per_night # => 250
properties[1].owner_id # => 1

# 2. Create a new property

repo = PropertyRepository.new

new_property = Property.new
new_property.property_name = 'Hovership'
new_property.property_description = 'Ship that hovers 50 feet off the ground!!"
new_property.price_per_night = 400
new_property.owner_id = 2

repo.create(new_property)

repo.all.length # => 4
repo.all.last['property_name'] => 'Hovership'

7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_properties_table
  seed_sql = File.read('spec/seeds_properties.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

before(:each) do 
  reset_properties_table
end

  # (your tests will go here).
end
8. Test-drive and implement the Repository class behaviour

After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.