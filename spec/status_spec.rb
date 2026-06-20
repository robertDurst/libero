require_relative "../api/status"

# Stand-in for the WEBrick response object Vercel passes to the handler.
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

RSpec.describe "GET /status" do
  it "returns 200 with body 'ok'" do
    response = FakeResponse.new
    Handler.call(nil, response)

    expect(response.status).to eq(200)
    expect(response.body).to eq("ok")
    expect(response["Content-Type"]).to eq("text/plain")
  end
end
