require 'property_repository'

RSpec.describe PropertyRepository do
  def reset_tables
    seed_sql = File.read('spec/seeds_tables.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end
  
  before(:each) do 
    reset_tables
  end

  describe '#all' do
    it 'returns every instance of property' do
      repo = PropertyRepository.new

      properties = repo.all

      expect(properties.length).to eq 3
      
      expect(properties[0].id).to eq '1'
      expect(properties[0].property_name).to eq 'Spaceship-style treehouse'
      expect(properties[0].property_description).to eq 'you\'ll be sure to have an out of this world experience in our UFO-styled treehouse'
      expect(properties[0].price_per_night).to eq '200'

      expect(properties[1].id).to eq '2'
      expect(properties[1].property_name).to eq 'Dome of the Future'
      expect(properties[1].property_description).to eq 'Our beautiful camping pods are modelled on the eden project domes'
      expect(properties[1].price_per_night).to eq '250'
    end
  end

  describe '#create' do
    it 'creates a new instance of property' do
      repo = PropertyRepository.new

      new_property = Property.new
      new_property.property_name = 'Hovership'
      new_property.property_description = 'Ship that hovers 50 feet off the ground!!'
      new_property.price_per_night = '400'
      new_property.owner_id = '2'

      repo.create(new_property)

      expect(repo.all.length).to eq 4
      expect(repo.all.last.property_name).to eq 'Hovership'
      expect(repo.all.last.property_description).to eq 'Ship that hovers 50 feet off the ground!!'
      expect(repo.all.last.price_per_night).to eq '400'
    end
  end
end



