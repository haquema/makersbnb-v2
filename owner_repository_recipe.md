

# SEEDS

```sql

TRUNCATE TABLE owners RESTART IDENTITY;
INSERT INTO owners (user_id) VALUES ('1');
INSERT INTO owners (user_id) VALUES ('2');


```
-------------------------------------------------------------------------------------

# CLASSES

```ruby


class OwnerRepository
  def all

  # SQL: 'SELECT id, owner_id FROM owners;'
  # Returns an array of posts
  end

  def find(id)

  #SQL: 'SELECT id, owner_id, user_id FROM posts WHERE id = $1;'
  # Returns a single owner
  end

  def create(owner)

  # SQL: 'INSERT INTO owners (user_id) VALUES($1);'
  # Doesn't need to return anything
  end

  def delete(id)

  # SQL: 'DELETE FROM owners WHERE id = $1;'
  # Doesn't need to return anything
  end

  def update(owner)

  # SQL: 'UPDATE owners SET owner_id = $1, user_id = $2 WHERE id = $3;'
  # Doesn't need to return anything
  end


```

-------------------------------------------------------------------------------------

# SPEC TESTS

```ruby

# 1
# Get all owners

repo = OwnerRepository.new

owners = repo.all
owners.first.id # =>
owners.length # =>
owners.first.owner_id # => 


# 2
# Get a single owner

repo = OwnerRepository.new

owner = repo.find(1)
owner.owner_id # =>
owner.user_id # =>


# 3
# Create a new owner

repo = OwnerRepository.new

owner = Owner.new
owner.owner_id # =>
owner.user_id # =>

owners = repo.all
repo.create(owners)

last_owner = owners.last

expect(last_owner.owner_id).to eq ('')
expect(last_owner.user_id).to eq ('')


# 4
# Delete an owner

# repo = OwnerRepository.new
# owners = repo.all
# repo.delete(1)

# expect(owners.length).to eq # =>
# expect(owners.first.id).to eq # =>


# 5
# Update an owner

# repo = OwnerRepository.new

# owner = repo.find(1)

# owner.owner_id => 
# owner.user_id => 

# updated_owner = repo.find(1)
# updated_owner.owner_id # =>
# updated_owner.user_id # =>


```