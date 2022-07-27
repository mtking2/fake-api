# fake api client for fake api
class FakeClient
	include HTTParty

	base_uri ENV['NGROK_URL']
	# base_uri 'http://127.0.0.1:4567'
	# base_uri 'https://a078-2600-6c5e-647f-6fe1-3944-d2e4-a07e-1838.ngrok.io/'

	format :json
	headers 'Content-Type' => 'application/json'

	def get_stuff
		api_get('/some_stuff', { foo: 'bar' })
	end

	def post_stuff
		api_post('/some_stuff', { foo: 'bar' })
	end

	protected

	def api_get(path, params)
		puts "api_get(#{path}, #{params.to_json.inspect})"
		self.class.get(path, query: params)
	end

	def api_post(path, body)
		puts "api_post(#{path}, #{body.to_json.inspect})"
		self.class.post(path, body: body.to_json)
	end
end
