DROP TABLE IF EXISTS users; 

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username text,
  email_address text,
  password text
);

TRUNCATE TABLE users, owners, properties, bookings RESTART IDENTITY;


INSERT INTO users (username, email_address, password) VALUES ('aziz', 'aziz@gmail.com', 'hello1234');
INSERT INTO users (username, email_address, password) VALUES ('anthony', 'anthony@gmail.com', 'bye1234');
INSERT INTO owners (user_id) VALUES ('1');
INSERT INTO owners (user_id) VALUES ('2');
