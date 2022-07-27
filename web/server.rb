require 'sinatra'

configure { set :server, :puma }

get '/', provides: 'html' do
	request.host
	haml :index, locals: { host: request.host }
end
