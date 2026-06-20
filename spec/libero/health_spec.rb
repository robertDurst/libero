RSpec.describe Libero::Health do
  describe ".call" do
    it "renders 200 'ok' when the database round-trip succeeds" do
      allow(Libero::DB).to receive(:healthy?).and_return(true)
      response = FakeResponse.new

      described_class.call(FakeRequest.new("GET", "/health"), response)

      expect(response.status).to eq(200)
      expect(response.body).to eq("ok")
      expect(response["Content-Type"]).to eq("text/plain")
      expect(response["Access-Control-Allow-Origin"]).to eq("*")
    end

    it "renders 503 'unhealthy' when the database is unreachable" do
      allow(Libero::DB).to receive(:healthy?).and_return(false)
      response = FakeResponse.new

      described_class.call(FakeRequest.new("GET", "/health"), response)

      expect(response.status).to eq(503)
      expect(response.body).to eq("unhealthy")
      expect(response["Access-Control-Allow-Origin"]).to eq("*")
    end
  end
end
