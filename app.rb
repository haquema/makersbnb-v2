require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/property_repository'
require_relative 'lib/user_repository'
require_relative 'lib/user'
require_relative 'lib/database_connection'
require_relative 'lib/booking_repository'

DatabaseConnection.connect('makersbnb')

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  get '/signup' do
    return erb(:signup)
  end

  get '/login' do
    return erb(:login)
  end

  post '/login' do
    email = params[:email]
    password = params[:password]

    @users = UserRepository.new.find(email)
    @type = type(@users)
    # if @users.length == 0
    #   return erb(:no_user_found)
    # else
    #   return erb(:logged_in)
    # end
    return erb(:logged_in)
  end

  get '/properties' do
    @properties = PropertyRepository.new.all
    return erb(:properties)
  end
end
