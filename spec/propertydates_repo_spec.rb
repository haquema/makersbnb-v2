require 'propertydate'
require 'propertydates_repository'

RSpec.describe PropertyDatesRepository do
  def reset_tables
    seed_sql = File.read('spec/test_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end

  after(:each) do
    reset_tables
  end
  
  describe '#find' do 
    it 'returns date record for specific booking' do
      repo = PropertyDatesRepository.new
      record = repo.find(1)

      expect(record.property_id).to eq('1')
      expect(record.unavailable_dates).to eq('2023-05-25+4')
    end
  end
end

