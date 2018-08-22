require 'sinatra'
require 'nokogiri'
require 'json'


before ['/json','/json/*'] do
  ct = request.media_type
  path = request.path
  halt 400, {'Content-Type' => 'text/plain'}, "Invalid Content Type #{ct} for endpoint #{path}" if ct != 'application/json'
end

post ['/json','/json/*'] do
  request.body.rewind
  json = JSON.parse request.body.read
  puts "I got some JSON: #{json.inspect}"
end

before ['/xml','/xml/*'] do
  ct = request.media_type
  path = request.path
  halt 400, {'Content-Type' => 'text/plain'}, "Invalid Content Type #{ct} for endpoint #{path}" if ct != 'text/xml'
end

post ['/xml','/xml/*'] do
  request.body.rewind
  xml = request.body.read
  puts "I got some XML:"
  puts Nokogiri::XML(xml)
end

get '/*' do
  content_type :json
  JSON({
    message: "hello, world!"
  })
end
