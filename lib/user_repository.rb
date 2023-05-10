require_relative 'user'
require 'bcrypt'

class UserRepository
  def all
    sql = 'SELECT id, name, email_address, phone, password FROM users;'
    # this result set will be an array of hashes
    result_set = DatabaseConnection.exec_params(sql, [])

    users = []

    result_set.each do |record|
      user = User.new
      user_object_mapping(user, record)
      users << user
    end

    return users 
  end

  def create(new_user)
    encrypted_password = BCrypt::Password.create(new_user.password)
    sql = 'INSERT into users (name, email_address, phone, password) VALUES ($1, $2, $3, $4)'
    params = [new_user.name, new_user.email_address, new_user.phone, encrypted_password]
    DatabaseConnection.exec_params(sql, params)
  end

  def find(email_address)
    # The SQL query executed here will return an empty array if no records are found
    sql = 'SELECT id, name, email_address, phone, password FROM users WHERE email_address = $1;'
    params = [email_address]
    result_set = DatabaseConnection.exec_params(sql, params)

    # Initialise a new User class and map the hash values to the User attributes so that we can access the records fields
    user = User.new
    user_object_mapping(user, result_set[0])
    return user
  end

  def find_by_id(id)
    # The SQL query executed here will return an empty array if no records are found
    sql = 'SELECT id, name, email_address, phone, password FROM users WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])
    # Initialise a new User class and map the hash values to the User attributes so that we can access the records fields
    user = User.new
    user_object_mapping(user, result_set[0])
    return user
  end

  def login(user, submitted_password)
    stored_password = BCrypt::Password.new(user.password)
    if stored_password == submitted_password
      return true
    else
      return false
    end
  end

  def check_unique_email(email)
    # Execute query to check if a user with the given email address already exists
    sql = sql = 'SELECT id, email_address FROM users WHERE email_address = $1'
    params = [email]
    result = DatabaseConnection.exec_params(sql, params)

    if !result.one?
      return true
    else
      return false
    end
  end

  private

  def user_object_mapping(object, record)
    object.id = record['id']
    object.name = record['name']
    object.email_address = record['email_address']
    object.phone = record['phone']
    object.password = record['password']
  end
end