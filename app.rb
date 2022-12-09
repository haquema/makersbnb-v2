require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/property_repository'
require_relative 'lib/database_connection'
require_relative 'lib/booking_repository'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    repo = PropertyRepository.new
    @properties = repo.all
    return erb(:index)
  end

  get '/properties' do
    repo = PropertyRepository.new
    @properties = repo.all
    return erb(:properties)
  end

  get '/new_property' do
    return erb(:new_property)
  end 

  get '/booking/new' do
    return erb(:new_booking)
  end

  post '/booking_task' do
    #Get request body parameters
    requested_dates = params[:requested_dates]
    property_id = params[:property_id]
    owner_id = params[:owner_id]
    user_id = params[:user_id]

    #Create a post in the database
    new_booking = Booking.new
    new_booking.requested_dates = requested_dates
    new_booking.property_id = property_id
    new_booking.owner_id = owner_id
    new_booking.user_id = user_id
    BookingRepository.new.create(new_booking)

    return erb(:booking_request)
  end 
end
