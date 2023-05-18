TRUNCATE TABLE users, properties, bookings, property_dates RESTART IDENTITY;

INSERT INTO users (name, email_address, phone, password) VALUES ('azizul haque', 'aziz@gmail.com', 1234567890, '$2a$12$mMb4WtpD.RDFlsmrnx5p8.GjJgloO12VxUuyc6L/ZxIY65Bw1HohO');
INSERT INTO users (name, email_address, phone, password) VALUES ('sameeul haque', 'samee@gmail.com', 9876543210, '$2a$12$mMb4WtpD.RDFlsmrnx5p8.GjJgloO12VxUuyc6L/ZxIY65Bw1HohO');

INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ('Modern City Apartment', 'You will be sure to have an out of this world experience in our UFO-styled treehouse', 500, true, 1);
INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ('Beachside Condo', 'sun, sea and the cool breeze - what more could you ask for?', 400, true, 2);
INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ('Cottage', 'escape the busy city and enjoy the idyllic countrysides of southern England', 200, true, 1);
INSERT INTO properties (name, description, price, to_rent, user_id) VALUES ('Family Home', 'Perfect first time home for young couples looking to grow their family', 250, true, 2);


INSERT INTO bookings (property_id, booker_id, start_date, end_date, status) VALUES (1, 2, '2023-05-25', '2023-05-29', 'confirmed');
INSERT INTO bookings (property_id, booker_id, start_date, end_date, status) VALUES (1, 2, '2023-05-30', '2023-05-31', 'confirmed');
INSERT INTO bookings (property_id, booker_id, start_date, end_date, status) VALUES (2, 1, '2023-05-29', '2023-06-06', 'pending');

INSERT INTO property_dates (property_id, booking_id, unavailable_dates) VALUES (1, 1, '2023-05-25 2023-05-26 2023-05-27 2023-05-28 2023-05-29');
INSERT INTO property_dates (property_id, booking_id, unavailable_dates) VALUES (1, 2, '2023-05-30 2023-05-31');
