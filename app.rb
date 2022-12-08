require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/property_repository'
require_relative 'lib/database_connection'

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

  post '/new_property' do
    
    repo = PropertyRepository.new

    property_name = params[:property_name]
    property_description = params[:property_description]
    price_per_night = params[:price_per_night]

    new_property = Property.new
    new_property.property_name = property_name
    new_property.property_description = property_description
    new_property.price_per_night = price_per_night

    repo.create(new_property)

    redirect('/properties')
  end
end