require 'sinatra'
require 'nokogiri'
require 'json'
require 'pry'

configure { set :server, :puma }

# set this to true if you want to match any and all routes.
# defaults to JSON and XML specific endpoints while rejecting root and undefined routes.
@match_all = true

if @match_all # match any and all routes for GET & POST and treat as JSON

	# before '/*' do
	#   ct = request.media_type
	#   path = request.path
	#   method = request.request_method
	#
	#   # force content-type
	#   # if ct != 'application/json' && method == 'POST'
	#   #   halt 400, { 'Content-Type' => 'text/plain' }, "Invalid Content Type #{ct} for endpoint #{path}"
	#   # end
	# end

	get '/*' do
		content_type :json
		puts "I got some params: #{request.params.inspect}" unless request.params.empty?
		{ message: 'hello, world!' }.to_json
	end

	post '/*' do
		content_type :json
		puts request.body.read
		request.body.rewind
		json = JSON.parse request.body.read
		puts "I got some JSON: #{json.inspect}"
		# halt 400, { message: 'Something went wrong' }.to_json

		{ hello: 'goodbye' }.to_json
	end

	patch '/*' do
		content_type :json
		request.body.rewind
		json = JSON.parse request.body.read
		puts "I got some JSON: #{json.inspect}"
	end

else # use JSON and XML specific endpoints. Reject / and undefined

	require_relative 'custom_routes'

end
