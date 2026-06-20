RSpec.describe Libero::Version do
  describe ".call" do
    it "renders the library version as plain text with CORS headers" do
      response = FakeResponse.new
      described_class.call(FakeRequest.new("GET"), response)

      expect(response.status).to eq(200)
      expect(response.body).to eq(Libero::VERSION)
      expect(response["Content-Type"]).to eq("text/plain")
      expect(response["Access-Control-Allow-Origin"]).to eq("*")
    end
  end
end
