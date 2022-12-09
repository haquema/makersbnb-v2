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
      expect(response.body).to include('<p>Spaceship-style treehouse</p>')
      expect(response.body).to include('<p>you\'ll be sure to have an out of this world experience in our UFO-styled treehouse</p>')
      expect(response.body).to include('<p>200</p>')
    end

    it 'returns 404 Not Found' do
      response = get('/23')

      expect(response.status).to eq(404)
    end
  end

  context "GET /" do
    it 'returns 200 OK' do
      response = get('/properties')

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Spaceship-style treehouse</p>')
      expect(response.body).to include('<p>you\'ll be sure to have an out of this world experience in our UFO-styled treehouse</p>')
      expect(response.body).to include('<p>200</p>')
    end
  end

  context "GET /new_property" do
    it 'returns 200 OK' do
      response = get('/new_property')

      expect(response.status).to eq(200)
      expect(response.body).to include('<div id="emailHelp" class="form-text">We\'ll never share your email with anyone else.</div>')
    end
  end

  context 'GET /bookings/new' do
    it 'should return the html form to create a new booking' do
      response = get('/booking/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/booking_task"/>')
      expect(response.body).to include('<input type="date" name="requested_dates"/>')
      expect(response.body).to include('<input type="number" name="propery_id"/>')
      expect(response.body).to include('<input type="number" name="owner_id"/>')
      expect(response.body).to include('<input type="number" name="user-id"/>')
    end
  end

  context 'POST /booking_task' do
    it 'should create a booking task and return a confirmation page' do
      response = post('/booking_task')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>You booking was requested!</h1>')
    end
  end
end