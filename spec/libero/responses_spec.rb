RSpec.describe Libero::Responses do
  let(:response) { FakeResponse.new }

  describe ".text" do
    it "sets status, body, content type and CORS headers" do
      described_class.text(response, 200, "hi")

      expect(response.status).to eq(200)
      expect(response.body).to eq("hi")
      expect(response["Content-Type"]).to eq("text/plain")
      expect(response["Access-Control-Allow-Origin"]).to eq("*")
    end

    it "applies extra headers when given" do
      described_class.text(response, 200, "hi", headers: { "X-Test" => "1" })
      expect(response["X-Test"]).to eq("1")
    end
  end

  describe ".no_content" do
    it "produces an empty 204 with CORS headers" do
      described_class.no_content(response)

      expect(response.status).to eq(204)
      expect(response.body).to eq("")
      expect(response["Access-Control-Allow-Methods"]).to eq("GET, OPTIONS")
    end
  end

  describe ".not_found" do
    it "produces a 404" do
      described_class.not_found(response)

      expect(response.status).to eq(404)
      expect(response.body).to eq("not found")
    end
  end

  describe ".method_not_allowed" do
    it "produces a 405 with an Allow header" do
      described_class.method_not_allowed(response, "GET, OPTIONS")

      expect(response.status).to eq(405)
      expect(response["Allow"]).to eq("GET, OPTIONS")
    end
  end
end
