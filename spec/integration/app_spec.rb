require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'


describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /" do
    it 'returns 200 OK' do
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Welcome to makersBNB</h1>')
      expect(response.body).to include('<p>Name: Modern City Apartment<p>')
      expect(response.body).to include('<p>Name: Beachside Condo<p>')
      expect(response.body).to include('<p>Name: Family Home<p>')
    end
  end

  context "GET /properties" do
    xit 'returns 200 OK' do
      response = get('/properties')

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Modern City Apartment</p>')
      expect(response.body).to include('<p>You will be sure to have an out of this world experience in our UFO-styled treehouse</p>')
      expect(response.body).to include('<p>£500</p>')
    end
  end

  context "GET /new_property" do
    xit 'returns 200 OK' do
      response = get('/new_property')

      expect(response.status).to eq(200)
      expect(response.body).to include('<label for="property_name" class="form-label">Property Name</label>')
    end
  end

  context "POST /new_property" do
    xit 'creates a new property' do
      response = post('/new_property?property_name=NewSpace&property_description=Incredible&price_per_night=330')

      expect(response.status).to eq(302)
      expect(response.body).to eq ''
    end
  end

  context "GET /signup" do
    it 'returns 200 and the signup form' do
      response = get('/signup')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Signup</h1>')
      expect(response.body).to include('<form action="/signup" method="POST">')
      expect(response.body).to include('<input type="text" name="name">')
      expect(response.body).to include('<input type="email" name="email">')
      expect(response.body).to include('<input type="bigint" name="phone">')
      expect(response.body).to include('<input type="password" name="password">')
      expect(response.body).to include('<input type="submit" value="Signup">')
    end
  end

  context "POST /signup" do
    it 'returns 201 when all provided details are suitable' do
      response = post('/signup', name: 'masuda', email: 'masuda@gmail.com', phone: 74563458791, password: 'happyday')
      
      expect(response.status).to eq(201)
      expect(response.body).to include("<h1>Congrats, you're account has been registered!</h1>")
    end

    # it 'returns '
  end

  # context "GET /login" do
  #   it 'returns 200' do
  #     response = get('/signup')

  #     expect(response.status).to eq(200)
  #     expect(response.body).to include('<h2>Welcome to MakersBnB!</h2>')
  #   end
  # end

  # context "POST /login" do
  #   it 'inserts a new user' do
  #     response = post('/signup?username=Moana&email_address=mqueen@islandmail.com&password=test')
  #     # encrypted_password = BCrypt::Password.create(:password)
  #     repo = UserRepository.new
      
  #     expect(repo.all.length).to eq 3
  #     expect(response.status).to eq(302)
  #     # expect(repo.all.password).to eq BCrypt::Password.create('test')
  #     expect(repo.all.last.password).to eq('test')
  #   end
  # end

  context 'GET /bookings/new' do
    xit 'should return the html form to create a new booking' do
      response = get('/booking/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/booking_task">')
      expect(response.body).to include('<input type="date" class="form-control" name="requested_dates"/>')
      expect(response.body).to include('<input type="number" class="form-control" name="property_id"/>')
      expect(response.body).to include('<input type="number" class="form-control" name="owner_id"/>')
      expect(response.body).to include('<input type="number" class="form-control" name="user_id"/>')
    end
  end

  context 'POST /booking_task' do
    xit 'should create a booking task and return a confirmation page' do
      response = post('/booking_task')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Your booking request has been sent to the host!</h1>')
    end
  end
end