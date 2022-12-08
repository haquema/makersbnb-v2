DROP TABLE IF EXISTS bookings; 

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  requested_dates date,
  property_id int,
  owner_id int,
  user_id int
);

TRUNCATE TABLE users, owners, properties, bookings, available_dates RESTART IDENTITY CASCADE;

INSERT INTO users (username, email_address, password) VALUES ('aziz', 'aziz@gmail.com', 'hello1234');
INSERT INTO users (username, email_address, password) VALUES ('anthony', 'anthony@gmail.com', 'bye1234');
INSERT INTO owners (user_id) VALUES ('1');
INSERT INTO owners (user_id) VALUES ('2');
INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ('Spaceship-style treehouse', 'you''ll be sure to have an out of this world experience in our UFO-styled treehouse', 200, 1);
INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ('Dome of the Future', 'Our beautiful camping pods are modelled on the eden project domes', 250, 1);
INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ('Starship Enterprise in the Forest', 'Get the ultimate star-trek experience right in the heart of the new forest', 500, 1);
INSERT INTO bookings (requested_dates, property_id, owner_id, user_id) VALUES ('2022-12-07', 1, 1, 1);