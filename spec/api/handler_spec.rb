require_relative "../../api/index"

# End-to-end smoke test that the Vercel handler dispatches through the
# real route table in Libero.routes.
RSpec.describe "api/index Handler" do
  it "serves /status for GET" do
    response = FakeResponse.new
    Handler.call(FakeRequest.new("GET", "/status"), response)

    expect(response.status).to eq(200)
    expect(response.body).to eq("ok")
  end

  it "serves /version for GET" do
    response = FakeResponse.new
    Handler.call(FakeRequest.new("GET", "/version"), response)

    expect(response.status).to eq(200)
    expect(response.body).to eq(Libero::VERSION)
  end

  it "404s an unknown path" do
    response = FakeResponse.new
    Handler.call(FakeRequest.new("GET", "/does-not-exist"), response)

    expect(response.status).to eq(404)
    expect(response.body).to eq("not found")
  end
end
