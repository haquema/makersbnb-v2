{{TABLE NAME}} Model and Repository Classes Design Recipe
Copy this recipe template to design and implement Model and Repository classes for a database table.

1. Design and create the Table
If the table is already created in the database, you can skip this step.

Otherwise, follow this recipe to design and create the SQL schema for your table.

In this template, we'll use an example table students

# EXAMPLE

Table: Bookings

Columns:
property_id | user_id | owner_id | requested_dates

2. Create Test SQL seeds
Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users, owners, properties, bookings, available_dates RESTART IDENTITY CASCADE;


INSERT INTO users (username, email_address, password) VALUES ('aziz', 'aziz@gmail.com', 'hello1234');
INSERT INTO users (username, email_address, password) VALUES ('anthony', 'anthony@gmail.com', 'bye1234');
INSERT INTO owners (user_id) VALUES ('1');
INSERT INTO owners (user_id) VALUES ('2');
INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ('Spaceship-style treehouse', 'you''ll be sure to have an out of this world experience in our UFO-styled treehouse', 200, 1);
INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ('Dome of the Future', 'Our beautiful camping pods are modelled on the eden project domes', 250, 1);
INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ('Starship Enterprise in the Forest', 'Get the ultimate star-trek experience right in the heart of the new forest', 500, 1);
INSERT INTO bookings (requested_dates, property_id, owner_id, user_id) VALUES ('07/12/2022', 1, 1, 1);

psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql

3. Define the class names
Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by Repository for the Repository class name.

# EXAMPLE
# Table name: bookings

# Model class
# (in lib/booking.rb)
class Booking
end

# Repository class
# (in lib/booking_repository.rb)
class BookingRepository
end
4. Implement the Model class
Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)

class Student

  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :cohort_name
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.

5. Define the Repository Class interface
Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

# EXAMPLE
# Table name: students

# Repository class
# (in lib/student_repository.rb)

class StudentRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, cohort_name FROM students;

    # Returns an array of Student objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, cohort_name FROM students WHERE id = $1;

    # Returns a single Student object.
  end

  # Add more methods below for each operation you'd like to implement.

  # def create(student)
  # end

  # def update(student)
  # end

  # def delete(student)
  # end
end
6. Write Test Examples
Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

# EXAMPLES

# 1
# Get all students

repo = StudentRepository.new

students = repo.all

students.length # =>  2

students[0].id # =>  1
students[0].name # =>  'David'
students[0].cohort_name # =>  'April 2022'

students[1].id # =>  2
students[1].name # =>  'Anna'
students[1].cohort_name # =>  'May 2022'

# 2
# Get a single student

repo = StudentRepository.new

student = repo.find(1)

student.id # =>  1
student.name # =>  'David'
student.cohort_name # =>  'April 2022'

# Add more examples for each method
Encode this example as a test.

7. Reload the SQL seeds before each test run
Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_students_table
  seed_sql = File.read('spec/seeds_students.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'students' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_students_table
  end

  # (your tests will go here).
end
8. Test-drive and implement the Repository class behaviour
After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.