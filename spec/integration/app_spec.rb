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
    it 'returns 200' do
      response = get('/new_property')

      expect(response.status).to eq(200)
      expect(response.body).to include('<label for="property_name" class="form-label">Property Name</label>')
    end
  end

  context "POST /new_property" do
    it 'creates a new property' do
      response = post('/new_property?property_name&property_description&price_per_night')

      expect(response.status).to eq(302)
      expect(response.body).to eq ''
    end
  end
end