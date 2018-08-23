require 'sinatra'
require 'nokogiri'
require 'pry-rails'
require 'json'

# set this to true if you want to match any and all routes.
# defaults to JSON and XML specific endpoints while rejecting root and undefined routes.
@match_all = false

unless @match_all # use JSON and XML specific endpoints. Reject / and undefined

  before ['/json','/json/*'] do
    ct = request.media_type
    path = request.path
    method = request.request_method

    if ct != 'application/json' && method == 'POST'
      halt 400, {'Content-Type' => 'text/plain'}, "Invalid Content Type #{ct} for endpoint #{path}"
    end
  end

  before ['/xml','/xml/*'] do
    ct = request.media_type
    path = request.path
    method = request.request_method
    
    if ct != 'text/xml' && method == 'POST'
      halt 400, {'Content-Type' => 'text/plain'}, "Invalid Content Type #{ct} for endpoint #{path}"
    end
  end

  # GET requests
  get ['/json','/json/*'] do
    content_type :json
    { message: "hello, world!" }.to_json
  end

  get ['/xml','/xml/*'] do
    content_type 'text/xml'
    Nokogiri::XML::Builder.new { |xml|
      xml.root {
        xml.foo {
          xml.bar 'some value'
        }
      }
    }.to_xml
  end

  # POST requests
  post ['/json','/json/*'] do
    request.body.rewind
    json = JSON.parse request.body.read
    puts "I got some JSON: #{json.inspect}"
  end

  post ['/xml','/xml/*'] do
    request.body.rewind
    xml = request.body.read
    puts "I got some XML:"
    puts Nokogiri::XML(xml)
  end

  # respond with 404 for root or undefined route for GET and/or POST
  get ['/','*a'] do
    halt 404, {'Content-Type' => 'text/plain'}, "Routing Error: No endpoint matching #{request.path}"
  end

  post ['/','*a'] do
    halt 404, {'Content-Type' => 'text/plain'}, "Routing Error: No endpoint matching #{request.path}"
  end

else # match any and all routes for GET & POST and treat as JSON

  before '/*' do
    ct = request.media_type
    path = request.path
    method = request.request_method

    if ct != 'application/json' && method == 'POST'
      halt 400, {'Content-Type' => 'text/plain'}, "Invalid Content Type #{ct} for endpoint #{path}"
    end
  end

  get '/*' do
    content_type :json
    { message: "hello, world!" }.to_json
  end

  post '/*' do
    request.body.rewind
    json = JSON.parse request.body.read
    puts "I got some JSON: #{json.inspect}"
  end

end
