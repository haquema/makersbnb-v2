# GET Route Design Recipe

## 1. Design the Route Signature

You'll need to include:
  * HTTP method: GET 
  * path: /

  * HTTP method: GET
  * path: /properties

## 2. Design the Response

<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->

```
{Property Name}
{Property Description}
{Price per night}

{Property Name}
{Property Description}
{Price per night}

{Property Name}
{Property Description}
{Price per night}

{Property Name}
{Property Description}
{Price per night}
```

## 3. Write Examples

```
# Request:

GET /

GET /properties


# Expected response:

Response for 200 OK
Return list:
<p>{Property Name}</p>
<p>{Property Description}</p>
<p>{Price per night}</p>

<p>{Property Name}</p>
<p>{Property Description}</p>
<p>{Price per night}</p>

Response for 200 OK
Return Karim Julia Mary
# Request:

GET /properties
<p>{Property Name}</p>
<p>{Property Description}</p>
<p>{Price per night}</p>

<p>{Property Name}</p>
<p>{Property Description}</p>
<p>{Price per night}</p>



# Expected response:

Response for 404 Not Found
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }


  context "GET /" do
    it 'returns 200 OK' do
      # Assuming there gets request with 3 defined names.
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>{Property Name}</p>')
      expect(response.body).to include('<p>{Property Description}</p>')
      expect(response.body).to include('<p>{Price per night}</p>')
    end

    it 'returns 404 Not Found' do
      response = get('/.')

      expect(response.status).to eq(404)
    end


  context "GET /properties" do
    it 'returns 200 OK' do
      # Assuming there gets request with 3 defined names.
      response = get('/properties')

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>{Property Name}</p>')
      expect(response.body).to include('<p>{Property Description}</p>')
      expect(response.body).to include('<p>{Price per night}</p>')
    end
  end

```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.