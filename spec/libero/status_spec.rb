RSpec.describe Libero::Status do
  describe ".call" do
    it "returns 200 'ok' with a CORS header for GET" do
      response = FakeResponse.new
      described_class.call(FakeRequest.new("GET"), response)

      expect(response.status).to eq(200)
      expect(response.body).to eq("ok")
      expect(response["Content-Type"]).to eq("text/plain")
      expect(response["Access-Control-Allow-Origin"]).to eq("*")
    end

    it "answers a CORS preflight (OPTIONS) with 204 and the headers" do
      response = FakeResponse.new
      described_class.call(FakeRequest.new("OPTIONS"), response)

      expect(response.status).to eq(204)
      expect(response.body).to eq("")
      expect(response["Access-Control-Allow-Origin"]).to eq("*")
      expect(response["Access-Control-Allow-Methods"]).to eq("GET, OPTIONS")
    end

    it "returns the response object" do
      response = FakeResponse.new
      expect(described_class.call(FakeRequest.new("GET"), response)).to be(response)
    end
  end
end
