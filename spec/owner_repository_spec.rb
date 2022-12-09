require 'owner_repository'
require 'owner'

def reset_tables
  seed_sql = File.read('spec/seeds_tables.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe OwnerRepository do
  before(:each) do 
    reset_tables
  end

  context "Owner Repository" do
    it "can get a list of all owners" do
      repo = OwnerRepository.new

      owners = repo.all
      expect(owners.first.id).to eq(1)
      expect(owners.length).to eq(2)
      expect(owners.first.user_id).to eq(1)
    end

    it "can find a single owner" do
      repo = OwnerRepository.new

      owner = repo.find(1)
      expect(owner.id).to eq(1)
      owner.user_id
    end

    it "can create a new owner" do
      repo = OwnerRepository.new

      repo.create_owner(2)

      owners = repo.all
      last_owner = owners.last

      expect(last_owner.id).to eq (3)
      expect(last_owner.user_id).to eq (2)
    end
  end
end
