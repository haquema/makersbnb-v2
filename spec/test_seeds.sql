TRUNCATE TABLE users, properties, bookings RESTART IDENTITY;

INSERT INTO users (name, email_address, phone, password) VALUES ('azizul haque', 'aziz@gmail.com', 1234567890, 'hello1234');
INSERT INTO users (name, email_address, phone, password) VALUES ('sameeul haque', 'samee@gmail.com', 9876543210, 'hello1234');

INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ('Modern City Apartment', 'You will be sure to have an out of this world experience in our UFO-styled treehouse', 500, true, 1);
INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ('Beachside Condo', 'sun, sea and the cool breeze - what more could you ask for?', 400, true, 2);
INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ('Cottage', 'escape the busy city and enjoy the idyllic countrysides of southern England', 200, true, 1);
INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ('Family Home', 'Perfect first time home for young couples looking to grow their family', 250, true, 2);


INSERT INTO bookings (property_id, booker_id, start_date, end_date, status) VALUES (1, 2, '2023-05-25', '2023-05-29', 'confirmed');
INSERT INTO bookings (property_id, booker_id, start_date, end_date, status) VALUES (3, 1, '2023-05-29', '2023-06-06', 'pending');