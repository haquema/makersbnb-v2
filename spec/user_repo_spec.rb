require 'user'
require 'user_repository'

def reset_tables
  seed_sql = File.read('spec/test_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_tables
  end

  context "UserRepository" do
    it "can get a list of all users" do
      repo = UserRepository.new

      users = repo.all
      expect(users[0].name).to eq('azizul haque')
      expect(users[0].email_address).to eq('aziz@gmail.com')
      expect(users[0].phone).to eq('1234567890')
      expect(users[1].name).to eq('sameeul haque')
      expect(users[1].email_address).to eq('samee@gmail.com')
      expect(users[1].phone).to eq('9876543210')
      
    end

    it "can find a single user" do
      repo = UserRepository.new

      user = repo.find('aziz@gmail.com')
      expect(user.name).to eq('azizul haque')
      expect(user.id).to eq('1')
      expect(user.phone).to eq('1234567890')
    end

    it "can find a user by id" do
      repo = UserRepository.new

      user = repo.find_by_id(1)
      expect(user.name).to eq('azizul haque')
      expect(user.email_address).to eq('aziz@gmail.com')
      expect(user.phone).to eq('1234567890')
    end

    it "can create a new user" do
      new_user = User.new
      new_user.name = 'emad haque'
      new_user.email_address = 'emad@gmail.com'
      new_user.phone = '1357924680'
      new_user.password = 'goodbye1357'
      repo = UserRepository.new

      
      repo.create(new_user)
      last_user = repo.all.last

      expect(last_user.id).to eq ('3')
      expect(last_user.name).to eq ('emad haque')
      expect(last_user.email_address).to eq ('emad@gmail.com')
      expect(last_user.phone).to eq ('1357924680')
    end
  end
end
