require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/property_repository'
require_relative 'lib/user_repository'
require_relative 'lib/user'
require_relative 'lib/database_connection'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    repo = PropertyRepository.new
    @properties = repo.all
    return erb(:index)
  end

  get '/signup' do
    return erb(:signup)
  end

  post '/signup' do
    repo = UserRepository.new

    new_user = User.new
    new_user.username = params[:username]
    new_user.email_address = params[:email_address]
    new_user.password = params[:password]

    repo.create(new_user)

    redirect('/properties')
  end

  get '/login' do
    return erb(:login)
  end

  post '/login' do
    email = params[:email]
    password = params[:password]

    user = User.new

    if user.password == password
      session[:user_id] = user.user_id
      redirect('/properties')
    else
      redirect('/login')
    end
  end

  get '/properties' do
    repo = PropertyRepository.new
    @properties = repo.all
    return erb(:properties)
  end

  get '/new_property' do
    return erb(:new_property)
  end
end