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
      record_to_object(user, record)
      users << user
    end

    return users 
  end

  def find(email_address)
    sql = 'SELECT id, name, email_address, phone, password FROM users WHERE id = $1;'
    # email_address must be unique
    params = [email_address]
    result_set = DatabaseConnection.exec_params(sql, params)

    user = User.new
    record_to_object(user, result_set)

    return user
  end

  def create(new_user)
    encrypted_password = Bcrypt::Password.create(new_user.password)
    sql = 'INSERT into users (name, email_address, phone, password) VALUES ($1, $2, $3, $4)'
    params = [new_user.username, new_user.email_address, new_user.phone, encrypted_password]
    DatabaseConnection.exec_params(sql, params)
  end

  private

  def record_to_object(user, record)
    record.each do |column, value|
      user.column = value
    end
  end
end