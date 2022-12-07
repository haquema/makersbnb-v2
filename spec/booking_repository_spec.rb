require 'booking'
require 'booking_repository'

def reset_bookings_table
  seed_sql = File.read('spec/seeds_bookings_table.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe BookingRepository do
  before(:each) do 
    reset_bookings_table
  end

  it 'returns all bookings' do
    repo = BookingRepository.new

    bookings = repo.all
    
    expect(bookings.length).to eq(1)
    expect(bookings.first.requested_dates).to eq('2022-07-12')
    expect(bookings.first.property_id).to eq('1')
    expect(bookings.first.owner_id).to eq('1')
    expect(bookings.first.user_id).to eq('1')
  end

  
end