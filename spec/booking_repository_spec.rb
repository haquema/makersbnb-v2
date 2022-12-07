require 'booking_repository'

RSpec.describe BookingRepository do
  def reset_bookings_table
    seed_sql = File.read('spec/seeds_bookings.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end
    
  before(:each) do 
    reset_bookings_table
  end
  
  describe '#all' do 
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

  describe '#find' do
    it 'finds and returns a single booking' do
      repo = BookingRepository.new

      booking = repo.find(1)
      expect(booking.id).to eq(1)
      expect(booking.requested_dates).to eq('2022-07-12')
    end
  end

  describe '#create' do
    it 'creates a new instance of booking' do
      repo =  BookingRepository.new

      new_booking = Booking.new
      new_booking.requested_dates = '25/12/2022'
      new_booking.property_id = '1'
      new_booking.owner_id = '1'
      new_booking.user_id = '1'

      repo.create(new_booking)

      expect(repo.all.length).to eq(2)
      expect(repo.all.last.requested_dates).to eq('2022-25-12')
      expect(repo.all.last.property_id).to eq('1')
      expect(repo.all.last.owner_id).to eq('1')
      expect(repo.all.last.user_id).to eq('1')
    end
  end
end