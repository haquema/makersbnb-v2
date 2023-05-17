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
      expect(record.unavailable_dates).to eq('2023-05-25 2023-05-26 2023-05-27 2023-05-28 2023-05-29')
    end
  end

  describe '#find_by_property' do 
    it 'returns date record for specific booking' do
      repo = PropertyDatesRepository.new
      records = repo.find_by_property(1)

      expect(records.length).to eq(2)
      expect(records.first.unavailable_dates).to eq('2023-05-25 2023-05-26 2023-05-27 2023-05-28 2023-05-29')
      expect(records.last.unavailable_dates).to eq('2023-05-30 2023-05-31')
    end
  end

end

