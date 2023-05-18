require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/property'
require_relative 'lib/property_repository'
require_relative 'lib/user_repository'
require_relative 'lib/user'
require_relative 'lib/database_connection'
require_relative 'lib/booking'
require_relative 'lib/booking_repository'
require_relative 'lib/propertydate'
require_relative 'lib/propertydates_repository'
require 'date'

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
    session[:path] = 'Signup'
    @path = session[:path]
    return erb(:login_signup)
  end

  get '/login' do
    session[:path] = 'Login'
    @path = session[:path]
    return erb(:login_signup)
  end

  post '/signup' do
    name, email, phone, password = params[:name], params[:email], params[:phone], params[:password]
    params_array = [name, email, phone, password]

    if UserRepository.new.check_unique_email(email)
      signup_user(params_array)
      status 201
      return erb(:signup_success)
    else
      status 400
      return erb(:email_taken)
    end
  end

  post '/login' do
    email, password = params[:email], params[:password]
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
    unav_start, unav_end = params[:unav_start], params[:unav_end]
    new_property = Property.new
    new_property.name = name
    new_property.description = description
    new_property.price = price
    new_property.to_rent = to_rent
    new_property.date_unavailable = unav_start.to_s + unav_end.to_s
    new_property.user_id = user_id
    PropertyRepository.new.create(new_property)
    
    redirect '/myaccount/properties'
  end

  get '/properties/:id' do
    @user_id = session[:user_id]
    id = params[:id]
    @property = PropertyRepository.new.find_by_id(id)
    @dates = dates_generator(unav_dates_list(id))
    return erb(:property_page)
  end

  get '/properties/:id/update' do
    @id = params[:id]
    return erb(:property_form)
  end

  post '/properties/:id/update' do
    # obtain params
    id, name, description = params[:id], params[:name], params[:description]
    price, to_rent = params[:price], params[:to_rent]
    # find property to update
    repo = PropertyRepository.new
    property = repo.find_by_id(id)
    # create new property object and set attributes to updated details
    updated_property = Property.new
    updated_property.id = id
    name != '' ? updated_property.name = name : updated_property.name = property.name
    description != '' ? updated_property.description = description : updated_property.description = property.description
    price != '' ? updated_property.price = price : updated_property.price = property.price
    to_rent != '' ? updated_property.to_rent = to_rent : updated_property.to_rent = property.to_rent
    updated_property.date_unavailable = property.date_unavailable

    # update database by calling update method on repo and providing updated property object as argument
    repo.update(updated_property)

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
      @properties = @properties.sort { |property1, property2| property1.id <=> property2.id }
      return erb(:properties)
    end
  end

  get '/myaccount/booking_requests' do
    @user_id = session[:user_id]
    @bookings = BookingRepository.new.find_by_booker(@user_id)
    return erb(:bookings_list)
  end

  post '/:property_id/bookings/new' do
    property_id= params[:property_id]
    booker_id = params[:booker_id]
    start_date = params[:start]
    end_date = params[:end]

    if booker_id == nil
      redirect '/login'
    end

    params_array = [property_id, booker_id, start_date, end_date]
    booking = Booking.new
    booking.property_id = params_array[0]
    booking.booker_id = params_array[1]
    booking.start_date = params_array[2]
    booking.end_date = params_array[3]
    BookingRepository.new.create(booking)

    session[:message] = "Booking requested successfully"
    redirect '/myaccount/booking_requests'
  end

  
  # get '/account/:id' do
  #   id = params[:id]
  #   @user = user = UserRepository.new.find_by_id(id)
  #   return erb(:user_account)
  # end

  private 

  def signup_user(params_array)
    repo = UserRepository.new
    new_user = User.new
    new_user.name = params_array[0]
    new_user.email_address = params_array[1]
    new_user.phone = params_array[2]
    new_user.password = params_array[3]
    repo.create(new_user)
  end

  def dates_generator(unav_dates_array = nil)
    unav_dates_array.length != nil ? unav_dates_array : unav_dates_array = []
    min = Date.today
    max = min + 14
    dates = []
    while min <= max
      if unav_dates_array.include? min
        min += 1
      else
        dates.append(min)
        min += 1
      end
    end
    return dates
  end

  def unav_dates_list(property_id)
    records = PropertyDatesRepository.new.find_by_property(property_id)
    unav_dates_array = []
    records.each do |record|
      record_dates = record.unavailable_dates.split(" ")
      for i in record_dates
        unav_dates_array << string_to_date(i)
      end
    end
    return unav_dates_array
  end


  def string_to_date(date_string)
    arr = date_string.split("-").map {|x| x.to_i}
    return Date.new(arr[0], arr[1], arr[2])
  end

  def place_booking(params_array)
    repo = BookingRepository.new
    booking = Booking.new
    booking.property_id = params_array[0]
    booking.booker_id = params_array[1]
    booking.start_date = params_array[2]
    booking.end_date = params_array[3]
    repo.create(booking)
  end
end
