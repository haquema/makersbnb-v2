require_relative 'user'
require 'bcrypt'

class UserRepository
  def all
    sql = 'SELECT id, username, email_address, password FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])

    users = []

    result_set.each do |record|
      user = User.new
      user.id = record['id']
      user.username = record['username']
      user.email_address = record['email_address']
      user.password = record['password']

      users << user
    end

    return users 
  end

  def find(email_address)
    sql = 'SELECT id, username, email_address, password FROM users WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [email_address])

    user = User.new
    user.id = result_set[0]['id'].to_i
    user.username = result_set[0]['username']
    user.email_address = result_set[0]['email_address']
    user.password = result_set[0]['password']

    return user
  end

  def create(new_user)
    encrypted_password = Bcrypt::Password.create(new_user.password)
    sql = 'INSERT into users (username, email_address, password) VALUES ($1, $2, $3)'
    params = [new_user.username, new_user.email_address, encrypted_password]
    DatabaseConnection.exec_params(sql, params)
  end
end