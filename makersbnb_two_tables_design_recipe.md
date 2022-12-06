# Two Tables Design Recipe Template

Copy this recipe template to design and create two related database tables from a specification.

1. Extract nouns from the user stories or specification

# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

As a property owner
I want to be able to sign up 
so that I can list a new property.

As a property owner
I want to be able to list multiple spaces
so that I can have multiple listings.

As a property owner
I should be able to name my space, provide a short description of the property, and a price per night
so that I have control over how I advertise my space.

As a property owner
I should be able to offer a range of dates where my space is available
so that I don't have clashing bookings, and control the availability of my location, as well as automate the process of booking my property.

As a renter
I want to be able to request to hire any space for one night
so that I can make a booking, 

As a property owner
I want to be able to confirm my booking request,
so that any property can still be booked for that night until I have confirmed my booking.

As a renter
I want to be able to see a list of available properties for a given date 
so that I can make the best choice for my needs.



Nouns: owner, renter, property, listing, property_name, property_description, space_price, available_properties, available_dates, booking, booking_dates, booking_confirmation



2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.


Record            Properties
---------------------------------------------------------------------------
Users             Name, Type (?), Email, Password

Properties        Name, Description, Price per Night, Available Dates

Bookings          Property name, Renter Name, Renter Email, Booking Date

Available Dates   Date, Property ID, Date Available? (Y/N)
---------------------------------------------------------------------------



Name of the first table (always plural): Users

Column names: username, user_type, email_address, password


Name of the second table (always plural): Properties

Column names: property_name, description, price_per_night


Name of the third table: Bookings

renter_name, renter_email_address, booking_date, property_id


Name of fourth table: Available dates:

date, property_id, date_available? (Y/N)

3. Decide the column types.

Here's a full documentation of PostgreSQL data types.

Most of the time, you'll need either text, int, bigint, numeric, or boolean. If you're in doubt, do some research or ask your peers.

Remember to always have the primary key id as a first column. Its type will always be SERIAL.

# EXAMPLE:


Table: users
id: SERIAL
username: text
email_address: text
password: text

Table: owners
id: SERIAL
name: text
email_address: text
password: text

Table: properties
id: SERIAL
property_name: text
description: text
price_per_night: int
user: int

Table: bookings
id: SERIAL
renter_name: text
renter_email_address: text
booking_date: DATE
property_id: int

table: available_dates
date: DATE
property_id: int
date_available: boolean



4. Decide on The Tables Relationship

Most of the time, you'll be using a one-to-many relationship, and will need a foreign key on one of the two tables.

To decide on which one, answer these two questions:

Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No)
Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)
You'll then be able to say that:

[A] has many [B]
And on the other side, [B] belongs to [A]
In that case, the foreign key is in the table [B]
Replace the relevant bits in this example with your own:

# EXAMPLE

1. Can one user have many properties? YES
2. Can one property have many users? NO

-> Therefore,
-> An artist HAS MANY albums
-> An album BELONGS TO an artist

-> Therefore, the foreign key is on the albums table.
If you can answer YES to the two questions, you'll probably have to implement a Many-to-Many relationship, which is more complex and needs a third table (called a join table).

4. Write the SQL.


```sql

DATABASE NAME - makersbnb + makersbnb_test

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username text,
  email_address text,
  password text
);

CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

CREATE TABLE properties (
  id SERIAL PRIMARY KEY,
  property_name text,
  property_description text,
  price_per_night int,
  owner_id int,
  constraint fk_owner foreign key(owner_id)
    references owners(id)
    on delete cascade
);

CREATE TABLE available_dates (
  id SERIAL PRIMARY KEY,
  date DATE,
  property_id int,
  available BOOLEAN,
  constraint fk_property foreign key(property_id)
    references properties(id)
    on delete cascade
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
 
  constraint fk_owner foreign key(owner_id)
    references owners(id)
    on delete cascade
);

```

5. Create the tables.

psql -h 127.0.0.1 database_name < albums_table.sql
