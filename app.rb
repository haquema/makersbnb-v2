require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/property_repository'
require_relative 'lib/user_repository'
require_relative 'lib/user'
require_relative 'lib/database_connection'
require_relative 'lib/booking_repository'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @message = session[:message]
    @properties = PropertyRepository.new.all
    return erb(:index)
  end

  get '/signup' do
    return erb(:signup)
  end

  post '/signup' do
    name = params[:name]
    email = params[:email]
    phone = params[:phone]
    password = params[:password]
    
    repo = UserRepository.new

    if repo.check_unique_email(email)
      new_user = User.new
      new_user.name = name
      new_user.email_address = email
      new_user.phone = phone
      new_user.password = password
      repo.create(new_user)
      status 201
      return erb(:signup_success)
    else
      return erb(:email_taken)
    end
  end

  get '/login' do
    return erb(:login)
  end

  post '/login' do
    email = params[:email]
    password = params[:password]
    repo = UserRepository.new
    
    if repo.all.any? {|record| record.email_address == email}
      user = repo.find(email)
      if repo.login(user, password)
        session[:user_id] = user.id
        session[:message] = 'Successful login'
        redirect '/'
      else
        session[:message] = 'Incorrect password'
        return erb(:login_fail)
      end 
    else
      session[:message] = "No account with this email"
      return erb(:user_nonexistant)
    end
  end

  post '/logout' do
    session.clear
    session[:message] = 'Successfully logged out.'
    redirect '/'
  end

  get '/properties' do
    @properties = PropertyRepository.new.all
    return erb(:properties)
  end

  get '/myaccount' do
    if session[:message] != 'Successful login'
      # No user id in the session
      # so the user is not logged in.
      return redirect('/login')
    else
      user_id = session[:user_id]
      @user = UserRepository.new.find_by_id(user_id)
      # @properties = PropertyRepository.new.find_by_owner(session[:user_id])
      return erb(:user_account)
    end
  end

  get '/myaccount/properties' do
    if session[:message] != 'Successful login'
      # No user id in the session
      # so the user is not logged in.
      return redirect('/login')
    else
      @user_id = session[:user_id]
      @properties = PropertyRepository.new.find_by_owner(@user_id)
      return erb(:properties)
    end
  end
  
  # get '/account/:id' do
  #   id = params[:id]
  #   @user = user = UserRepository.new.find_by_id(id)
  #   return erb(:user_account)
  # end
end
