require 'user'
require 'user_repository'

def reset_users_table
  seed_sql = File.read('spec/seeds_users_table.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_users_table
  end

  it 'returns all users' do
    repo = UserRepository.new

    users = repo.all
    
    expect(users.length).to eq(2)
    expect(users.first.username).to eq('aziz')
    expect(users.first.email_address).to eq('aziz@gmail.com')
  end

  it 'creates a new user' do
    repo = UserRepository.new

    new_user = User.new
    new_user.username = 'eliza'
    new_user.email_address = 'eliza@gmail.com'
    new_user.password = 'ilovemakers'

    repo.create(new_user)

    expect(repo.all.length).to eq(3)
    expect(repo.all.last.username).to eq('eliza')
    expect(repo.all.last.email_address).to eq('eliza@gmail.com')
    expect(repo.all.last.password).to eq('ilovemakers') 
  end
end