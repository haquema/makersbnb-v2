DROP TABLE users, properties, bookings;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name text,
  email_address text,
  phone bigint,
  password text
);

CREATE TABLE properties (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price int,
  to_rent boolean,
  user_id int,
  CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  property_id int,
  CONSTRAINT fk_property FOREIGN KEY(property_id) REFERENCES properties(id) ON DELETE CASCADE,
  user_id int,
  CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
  start_date date,
  end_date date,
  status text
);