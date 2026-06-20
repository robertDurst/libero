require_relative "../api/status"

# Stand-ins for the WEBrick request/response objects Vercel passes to the handler.
class FakeRequest
  attr_reader :request_method

  def initialize(request_method)
    @request_method = request_method
  end
end

class FakeResponse
  attr_accessor :status, :body

  def initialize
    @headers = {}
  end

  def []=(key, value)
    @headers[key] = value
  end

  def [](key)
    @headers[key]
  end
end

RSpec.describe "status endpoint" do
  it "returns 200 'ok' with a CORS header for GET" do
    response = FakeResponse.new
    Handler.call(FakeRequest.new("GET"), response)

    expect(response.status).to eq(200)
    expect(response.body).to eq("ok")
    expect(response["Content-Type"]).to eq("text/plain")
    expect(response["Access-Control-Allow-Origin"]).to eq("*")
  end

  it "answers a CORS preflight (OPTIONS) with 204 and the headers" do
    response = FakeResponse.new
    Handler.call(FakeRequest.new("OPTIONS"), response)

    expect(response.status).to eq(204)
    expect(response["Access-Control-Allow-Origin"]).to eq("*")
    expect(response["Access-Control-Allow-Methods"]).to eq("GET, OPTIONS")
  end
end
