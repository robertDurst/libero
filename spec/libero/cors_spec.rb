RSpec.describe Libero::CORS do
  describe ".apply" do
    it "stamps the permissive CORS headers onto the response" do
      response = FakeResponse.new
      described_class.apply(response)

      expect(response["Access-Control-Allow-Origin"]).to eq("*")
      expect(response["Access-Control-Allow-Methods"]).to eq("GET, OPTIONS")
      expect(response["Access-Control-Allow-Headers"]).to eq("Content-Type")
    end

    it "returns the response" do
      response = FakeResponse.new
      expect(described_class.apply(response)).to be(response)
    end
  end

  describe ".preflight?" do
    it "is true for an OPTIONS request" do
      expect(described_class.preflight?(FakeRequest.new("OPTIONS"))).to be(true)
    end

    it "is false for a GET request" do
      expect(described_class.preflight?(FakeRequest.new("GET"))).to be(false)
    end

    it "is false when the request cannot report its method" do
      expect(described_class.preflight?(Object.new)).to be(false)
    end
  end
end
