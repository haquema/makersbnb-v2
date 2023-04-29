# Two Tables Design Recipe Template

Copy this recipe template to design and create two related database tables from a specification.

1. Extract nouns from the user stories or specification

# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

As a user: 
  I want to be able to sign up and login to my account
  I want to be able to modify my details

As a property owner:
  I want to see an inventory of the properties I am renting out
  I want to be able to add a new property to my inventory 
  I want to be able to remove a property from my inventory
  I want to be able to edit the details of a property
  I want to be able to make a property available for renting
  I want to be able to choose a property's available dates 
  I want to be able to see all booking requests made on my properties
  I want to be able to approve or reject requests and cancel preexisting bookings

As a renter:
  I want to be see a list of rentable properties
  I want to filter the properties by price
  I want to be able to make a request on a property
  I want to be able to be able to see a list of my booking requests/confirmed booking

user, name, email, phone_number, password

property, name, description, price, to_rent, available_dates

bookings, renter, property, property owner, start date, end date, status



2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.


Record            Properties
---------------------------------------------------------------------------
Users             Name, Email, Phone, Password

Properties        Name, Description, Price, ToRent, Owner

Bookings          Property, Renter, Start Date, End Date, Status
---------------------------------------------------------------------------



Name of the first table (always plural): Users

Column names: name, email_address, phone, password


Name of the second table (always plural): Properties

Column names: name, description, price, to_rent, owner


Name of the third table: Bookings

property, renter, owner, start_date, end_date, status

3. Decide the column types.

Most of the time, you'll need either text, int, bigint, numeric, or boolean. If you're in doubt, do some research or ask your peers.

Remember to always have the primary key id as a first column. Its type will always be SERIAL.

# EXAMPLE:


Table: users
id: SERIAL
name: text
email_address: text
phone: int
password: text

Table: properties
id: SERIAL
name: text
description: text
price: int
to_rent: boolean


Table: bookings
id: SERIAL
property: int FK
renter: FK
start_date: date
end_date: date
status: text




4. Decide on The Tables Relationship



Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No)
Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)
You'll then be able to say that:

Users to Properties is One to Many with foreign key in Properties
Users to Bookings is One to Many with foreign key in Bookings
Properties to Bookings is One to Many with foreign Key in Bookings


4. Write the SQL.


```sql

DATABASE NAME - makersbnb + makersbnb_test

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name text,
  email_address text,
  phone int,
  password text
);

CREATE TABLE properties (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price int,
  to_rent boolean,
  user_id int
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  property_id int,
  constraint fk_property foreign key(property_id)
    references properties(id)
    on delete cascade
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
  start_date: date
  end_date: date
  status: text
);


```

5. Create the tables.

psql -h 127.0.0.1 database_name < albums_table.sql
