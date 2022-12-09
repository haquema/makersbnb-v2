DROP TABLE IF EXISTS owners; 

CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

TRUNCATE TABLE users, owners, properties, bookings RESTART IDENTITY;
INSERT INTO users (username, email_address, password) VALUES ('aziz', 'aziz@gmail.com', 'hello1234');
INSERT INTO users (username, email_address, password) VALUES ('anthony', 'anthony@gmail.com', 'bye1234');
INSERT INTO owners (user_id) VALUES ('1');
INSERT INTO owners (user_id) VALUES ('2');
