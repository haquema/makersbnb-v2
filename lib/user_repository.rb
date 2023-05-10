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

  def find(email_address)
    sql = 'SELECT id, name, email_address, phone, password FROM users WHERE email_address = $1;'
    # email_address must be unique
    params = [email_address]
    result_set = DatabaseConnection.exec_params(sql, params)

    user = User.new
    user_object_mapping(user, result_set[0])

    return user
  end

  def create(new_user)
    encrypted_password = BCrypt::Password.create(new_user.password)
    sql = 'INSERT into users (name, email_address, phone, password) VALUES ($1, $2, $3, $4)'
    params = [new_user.name, new_user.email_address, new_user.phone, encrypted_password]
    DatabaseConnection.exec_params(sql, params)
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