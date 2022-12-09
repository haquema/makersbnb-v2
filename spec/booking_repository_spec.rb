require 'booking_repository'

RSpec.describe BookingRepository do
  def reset_tables
    seed_sql = File.read('spec/seeds_tables.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end
    
  before(:each) do 
    reset_tables
  end
  
  describe '#all' do 
    it 'returns all bookings' do
      repo = BookingRepository.new
      bookings = repo.all
      
      expect(bookings.length).to eq(1)
      expect(bookings.first.requested_dates).to eq('2022-12-07')
      expect(bookings.first.property_id).to eq('1')
      expect(bookings.first.owner_id).to eq('1')
      expect(bookings.first.user_id).to eq('1')
    end
  end

  describe '#find' do
    it 'finds and returns a single booking' do
      repo = BookingRepository.new

      booking = repo.find(1)
      expect(booking.id).to eq(1)
      expect(booking.requested_dates).to eq('2022-12-07')
    end
  end

  describe '#create' do
    it 'creates a new instance of booking' do
      repo =  BookingRepository.new

      new_booking = Booking.new
      new_booking.requested_dates = '2022-12-25'
      new_booking.property_id = '1'
      new_booking.owner_id = '1'
      new_booking.user_id = '1'

      repo.create(new_booking)

      expect(repo.all.length).to eq(2)
      expect(repo.all.last.requested_dates).to eq('2022-12-25')
      expect(repo.all.last.property_id).to eq('1')
      expect(repo.all.last.owner_id).to eq('1')
      expect(repo.all.last.user_id).to eq('1')
    end
  end
end