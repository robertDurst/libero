require_relative "../../api/status"

# Smoke test that the Vercel handler is wired to the Libero module.
RSpec.describe "api/status Handler" do
  it "serves the status response for GET" do
    response = FakeResponse.new
    Handler.call(FakeRequest.new("GET"), response)

    expect(response.status).to eq(200)
    expect(response.body).to eq("ok")
  end
end
