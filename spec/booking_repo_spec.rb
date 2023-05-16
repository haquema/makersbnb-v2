require 'booking'
require 'booking_repository'
require 'property'
require 'property_repository'

RSpec.describe BookingRepository do
  def reset_tables
    seed_sql = File.read('spec/test_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end

  after(:each) do
    reset_tables
  end
  
  describe '#all' do 
    it 'returns all bookings' do
      repo = BookingRepository.new
      bookings = repo.all
      
      expect(bookings.length).to eq(3)
      expect(bookings[0].property_id).to eq('1')
      expect(bookings[0].booker_id).to eq('2')
      expect(bookings[0].start_date).to eq('2023-05-25')
      expect(bookings[0].end_date).to eq('2023-05-29')
      expect(bookings[0].status).to eq('confirmed')
      expect(bookings[2].property_id).to eq('3')
      expect(bookings[2].booker_id).to eq('1')
      expect(bookings[2].start_date).to eq('2023-05-29')
      expect(bookings[2].end_date).to eq('2023-06-06')
      expect(bookings[2].status).to eq('pending')
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

      expect(repo.all.length).to eq(4)
      expect(repo.all.last.property_id).to eq('2')
      expect(repo.all.last.booker_id).to eq('2')
      expect(repo.all.last.start_date).to eq('2023-06-10')
      expect(repo.all.last.end_date).to eq('2023-06-15')
      expect(repo.all.last.status).to eq('pending')

      property = PropertyRepository.new.find_by_id(2)
      expect(property.date_unavailable).to eq('2023-06-102023-06-15')
    end
  end

  describe '#update' do
    it "updates an existing booking's dates" do
      repo =  BookingRepository.new
      existing_booking = repo.find(1)
      updated_booking = Booking.new
      updated_booking.start_date = '2023-05-26'
      updated_booking.end_date = existing_booking.end_date
      updated_booking.status = existing_booking.status
      repo.update(existing_booking, updated_booking)

      expect(BookingRepository.new.all.length).to eq(3)
      expect(BookingRepository.new.find(1).start_date).to eq('2023-05-26')
      property = PropertyRepository.new.find_by_id(1)
      expect(property.date_unavailable).to eq('2023-05-302023-05-31 2023-05-262023-05-29')
    end
  end
end