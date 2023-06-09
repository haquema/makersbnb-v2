require 'property_repository'

RSpec.describe PropertyRepository do
  def reset_tables
    seed_sql = File.read('spec/test_seeds.sql')
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

      expect(properties.length).to eq(4)
      
      expect(properties[0].name).to eq('Modern City Apartment')
      expect(properties[0].description).to eq 'You will be sure to have an out of this world experience in our UFO-styled treehouse'
      expect(properties[0].price).to eq '500'
      expect(properties[0].to_rent).to eq 't'
      expect(properties[0].user_id).to eq '1'

      expect(properties[2].name).to eq('Cottage')
      expect(properties[2].description).to eq 'escape the busy city and enjoy the idyllic countrysides of southern England'
      expect(properties[2].price).to eq '200'
      expect(properties[2].to_rent).to eq 't'
      expect(properties[2].user_id).to eq '1'
    end
  end

  describe '#create' do
    it 'creates a new instance of property' do
      repo = PropertyRepository.new

      new_property = Property.new
      new_property.name = 'Boathouse'
      new_property.description = 'Let the water rock you to sleep'
      new_property.price = '350'
      new_property.to_rent = false
      new_property.user_id = '2'

      repo.create(new_property)

      expect(repo.all.length).to eq 5
      expect(repo.all.last.name).to eq 'Boathouse'
      expect(repo.all.last.description).to eq 'Let the water rock you to sleep'
      expect(repo.all.last.price).to eq '350'
      expect(repo.all.last.to_rent).to eq 'f'
      expect(repo.all.last.user_id).to eq '2'
    end
  end

  describe '#update' do
    it 'updates an existing property' do
      repo = PropertyRepository.new
      property = repo.find_by_id(1)
      updated_prop = Property.new
      updated_prop.name = property.name
      updated_prop.description = property.description
      updated_prop.price = property.price
      updated_prop.to_rent = false
      updated_prop.id = property.id

      repo.update(updated_prop)

      expect(repo.all.length).to eq 4
      expect(repo.find_by_id(1).to_rent).to eq 'f'
      # expect(repo.all.last.description).to eq 'Let the water rock you to sleep'
      # expect(repo.all.last.price).to eq '350'
      # expect(repo.all.last.to_rent).to eq 'f'
      # expect(repo.all.last.user_id).to eq '2'
    end
  end

  describe '#find_by_owner' do
    it 'finds a property when searched by owner id' do
      repo = PropertyRepository.new
      property = repo.find_by_owner(1)
      expect(property[0].id).to eq('1')
      expect(property[0].name).to eq('Modern City Apartment')
      expect(property[0].description).to eq('You will be sure to have an out of this world experience in our UFO-styled treehouse')
      expect(property[0].price).to eq('500')
      expect(property[0].user_id).to eq('1')

      expect(property[1].id).to eq('3')
      expect(property[1].name).to eq('Cottage')
      expect(property[1].description).to eq('escape the busy city and enjoy the idyllic countrysides of southern England')
      expect(property[1].price).to eq('200')
      expect(property[1].user_id).to eq('1')
    end
  end

  describe '#find_by_id' do
    it 'finds a property when searched using the specific property id' do
      repo = PropertyRepository.new
      property = repo.find_by_id(1)
      expect(property.id).to eq('1')
      expect(property.name).to eq('Modern City Apartment')
      expect(property.description).to eq('You will be sure to have an out of this world experience in our UFO-styled treehouse')
      expect(property.price).to eq('500')
      expect(property.user_id).to eq('1')

      property = repo.find_by_id(2)
      expect(property.id).to eq('2')
      expect(property.name).to eq('Beachside Condo')
      expect(property.description).to eq('sun, sea and the cool breeze - what more could you ask for?')
      expect(property.price).to eq('400')
      expect(property.user_id).to eq('2')
    end
  end
end



