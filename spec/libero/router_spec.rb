RSpec.describe Libero::Router do
  let(:response) { FakeResponse.new }

  subject(:router) do
    described_class.new.get("/status") { |_req, res| Libero::Responses.text(res, 200, "ok") }
  end

  it "dispatches a matching GET route" do
    router.call(FakeRequest.new("GET", "/status"), response)

    expect(response.status).to eq(200)
    expect(response.body).to eq("ok")
  end

  it "answers a CORS preflight with 204 for any path" do
    router.call(FakeRequest.new("OPTIONS", "/anything"), response)

    expect(response.status).to eq(204)
    expect(response["Access-Control-Allow-Methods"]).to eq("GET, OPTIONS")
  end

  it "404s an unknown path" do
    router.call(FakeRequest.new("GET", "/nope"), response)

    expect(response.status).to eq(404)
    expect(response.body).to eq("not found")
  end

  it "405s a known path with the wrong method" do
    router.call(FakeRequest.new("POST", "/status"), response)

    expect(response.status).to eq(405)
    expect(response["Allow"]).to eq("GET, OPTIONS")
  end
end
