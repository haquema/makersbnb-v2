DROP TABLE IF EXISTS users, properties, bookings; 

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
  -- user_id int
  -- CONSTRAINT fk_user 
  --   FOREIGN KEY(user_id) 
  --     REFERENCES users(id)
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  property_id int,
  constraint fk_property 
    -- foreign key(property_id)
    --   references properties(id)
    --     on delete cascade
  user_id int,
  -- constraint fk_user 
  --   foreign key(user_id)
  --     references users(id)
  --       on delete cascade
  start_date: date
  end_date: date
  status: text
);



-- TRUNCATE TABLE users, properties, bookings RESTART IDENTITY CASCADE;

-- INSERT INTO users (username, email_address, phone, password) VALUES ('azizul haque', 'aziz@gmail.com', 1234567890, 'hello1234');
-- INSERT INTO users (username, email_address, phone, password) VALUES ('sameeul haque', 'samee@gmail.com', 9876543210, 'hello1234');

-- INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ('Spaceship Treehouse', 'you''ll be sure to have an out of this world experience in our UFO-styled treehouse', 200, 1, 1);
-- INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ('Beachside Condo', 'sun, sea and the cool breeze - what more could you ask for?', 300, 1, 2);

-- INSERT INTO bookings (property_id, user_id, start_date, end_date, status) VALUES (1, 2, 1, "2023-05-25", "2023-05-29" );