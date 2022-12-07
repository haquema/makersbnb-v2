require_relative 'user'

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

  def create(user)

    sql = 'INSERT into users (username, email_address, password) VALUES ($1, $2, $3)'
    params = [user.username, user.email_address, user.password]
    DatabaseConnection.exec_params(sql, params)
  end
end