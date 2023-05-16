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
    name, email, phone, password = params[:name], params[:email], params[:phone], params[:password]
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
      status 400
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
        session[:message] = 'Successful Login'
        redirect '/'
      else
        session[:message] = 'Incorrect Password'
        status 401
        return erb(:login_fail)
      end 
    else
      session[:message] = "No account with this email"
      status 400
      return erb(:user_nonexistant)
    end
  end

  post '/logout' do
    session.clear
    session[:message] = 'Successfully logged out.'
    redirect '/'
  end

  get '/properties' do
    session[:path] = "/properties"
    @path = session[:path]
    @properties = PropertyRepository.new.all
    return erb(:properties)
  end

  get '/properties/new' do
    return erb(:property_form)
  end

  post '/properties/new' do
    name, description, price, to_rent, user_id = params[:name], params[:description], params[:price], params[:to_rent], session[:user_id]
    new_property = Property.new
    new_property.name = name
    new_property.description = description
    new_property.price = price
    new_property.to_rent = to_rent
    new_property.user_id = user_id
    PropertyRepository.new.create(new_property)
    
    redirect '/myaccount/properties'
  end

  get '/properties/:id' do
    @user_id = session[:user_id]
    id = params[:id]
    @property = PropertyRepository.new.find_by_id(id)
    return erb(:property_page)
  end

  get '/properties/:id/update' do
    @id = params[:id]
    return erb(:property_form)
  end

  post '/properties/:id/update' do
    id, name, description, price, to_rent = params[:id], params[:name], params[:description], params[:price], params[:to_rent]
    property = PropertyRepository.new.find_by_id(id)
    updated_property = Property.new
    property.id = id
    name != '' ? updated_property.name = name : updated_property.name = property.name
    description != '' ? updated_property.description = description : updated_property.description = property.description
    price != '' ? updated_property.price = price : updated_property.price = property.price
    to_rent != '' ? updated_property.to_rent = to_rent : updated_property.to_rent = property.to_rent
    PropertyRepository.new.update(updated_property)

    redirect "/properties/#{id}"
  end

  get '/myaccount' do
    if session[:message] != 'Successful Login'
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
    if session[:user_id] == nil
      # No user id in the session
      # so the user is not logged in.
      return redirect('/login')
    else
      session[:path] = "/myaccount/properties"
      @path = session[:path]
      @properties = PropertyRepository.new.find_by_owner(session[:user_id])
      return erb(:properties)
    end
  end
  
  # get '/account/:id' do
  #   id = params[:id]
  #   @user = user = UserRepository.new.find_by_id(id)
  #   return erb(:user_account)
  # end
end
