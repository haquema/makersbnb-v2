require 'booking'
require 'booking_repository'

RSpec.describe BookingRepository do
  def reset_tables
    seed_sql = File.read('spec/test_seeds.sql')
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
      
      expect(bookings.length).to eq(2)
      expect(bookings[0].property_id).to eq('1')
      expect(bookings[0].booker_id).to eq('2')
      expect(bookings[0].start_date).to eq('2023-05-25')
      expect(bookings[0].end_date).to eq('2023-05-29')
      expect(bookings[0].status).to eq('confirmed')
      expect(bookings[1].property_id).to eq('3')
      expect(bookings[1].booker_id).to eq('1')
      expect(bookings[1].start_date).to eq('2023-05-29')
      expect(bookings[1].end_date).to eq('2023-06-06')
      expect(bookings[1].status).to eq('pending')
    end
  end

  describe '#find' do
    it 'finds and returns a single booking' do
      repo = BookingRepository.new

      booking = repo.find(1)
      expect(booking.property_id).to eq('1')
      expect(booking.booker_id).to eq('2')
      expect(booking.start_date).to eq('2023-05-25')
      expect(booking.end_date).to eq('2023-05-29')
      expect(booking.status).to eq('confirmed')
    end
  end

  describe '#create' do
    it 'creates a new instance of booking' do
      repo =  BookingRepository.new

      new_booking = Booking.new
      new_booking.property_id ='2'
      new_booking.booker_id = '2'
      new_booking.start_date = '2023-06-10'
      new_booking.end_date = '2023-06-15'
      new_booking.status = 'pending'

      repo.create(new_booking)

      expect(repo.all.length).to eq(3)
      expect(repo.all.last.property_id).to eq('2')
      expect(repo.all.last.booker_id).to eq('2')
      expect(repo.all.last.start_date).to eq('2023-06-10')
      expect(repo.all.last.end_date).to eq('2023-06-15')
      expect(repo.all.last.status).to eq('pending')

    end
  end
end