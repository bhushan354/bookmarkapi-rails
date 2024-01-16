require 'rails_helper'
# You can replace ‘Healths’ with any string you want, it is for your own documentation purpose.

# The "type: :request " will tell RSpec that this is a system test.

# Sometimes when testing a deeply nested JSON string response, we can make it easier to read by parsing it to a Ruby hash using JSON.parse like this :
# # by default, JSON has string key like {"status": "online"},
# # we then convert the key to symbol, {status: 'online'} for better readability, 
# # and type less two quotes character
# json = JSON.parse(response.body).deep_symbolize_keys


RSpec.describe "Healths", type: :request do
  describe "GET /index" do
    it "returns http success" do
      # this will perform a GET request to the /health/index route
      get "/health/index"

      # 'response' is a special object which contain HTTP response received after a request is sent
      # response.body is the body of the HTTP response, which here contain a JSON string
      expect(response.body).to eq('{"status":"online"}')

      # we can also check the http status of the response
      expect(response.status).to eq(200)
    end
  end

end
