TRUNCATE TABLE users, owners, properties, available_dates, bookings RESTART IDENTITY;
INSERT INTO users (username, email_address, password) VALUES ('aziz', 'aziz@gmail.com', 'hello1234');
INSERT INTO users (username, email_address, password) VALUES ('anthony', 'anthony@gmail.com', 'bye1234');
INSERT INTO owners (user_id) VALUES ('1');
INSERT INTO owners (user_id) VALUES ('2');
