DROP TABLE IF EXISTS properties; 

CREATE TABLE properties (
  id SERIAL PRIMARY KEY,
  property_name text,
  property_description text,
  price_per_night int,
  owner_id int
  -- constraint fk_owner foreign key(owner_id)
  --   references owners(id)
  --   on delete cascade
);

TRUNCATE TABLE properties RESTART IDENTITY CASCADE;

INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ('Spaceship-style treehouse', 'you''ll be sure to have an out of this world experience in our UFO-styled treehouse', 200, 1);
INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ('Dome of the Future', 'Our beautiful camping pods are modelled on the eden project domes', 250, 1);
INSERT INTO properties (property_name, property_description, price_per_night, owner_id) VALUES ('Starship Enterprise in the Forest', 'Get the ultimate star-trek experience right in the heart of the new forest', 500, 1);
