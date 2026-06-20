RSpec.describe Libero::Status do
  describe ".call" do
    it "renders 200 'ok' as plain text with CORS headers" do
      response = FakeResponse.new
      described_class.call(FakeRequest.new("GET"), response)

      expect(response.status).to eq(200)
      expect(response.body).to eq("ok")
      expect(response["Content-Type"]).to eq("text/plain")
      expect(response["Access-Control-Allow-Origin"]).to eq("*")
    end

    it "returns the response object" do
      response = FakeResponse.new
      expect(described_class.call(FakeRequest.new("GET"), response)).to be(response)
    end
  end
end
