require 'owner_repository'

def reset_owners_table
  seed_sql = File.read('spec/seeds_owners.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe OwnerRepository do
  before(:each) do 
    reset_owners_table
  end

  context "Owner Repository" do
    it "can get a list of all owners" do
      repo = OwnerRepository.new

      owners = repo.all
      expect(owners.first.id).to eq(1)
      expect(owners.length).to eq(2)
      expect(owners.first.user_id).to eq(1)
    end






  end
  end
