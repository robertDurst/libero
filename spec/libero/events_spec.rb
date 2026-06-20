RSpec.describe Libero::Events do
  let(:row) do
    { "date" => "2026-06-11", "time" => "21:00", "title" => "México vs Sudáfrica",
      "location" => "Ciudad de México (MX)", "type" => "Mundial" }
  end

  describe ".call" do
    it "renders the ordered schedule as a JSON array with CORS headers" do
      allow(Libero::DB).to receive(:connect!)
      allow(Libero::CalendarEvent).to receive(:ordered).and_return([double(as_event: row)])

      response = FakeResponse.new
      described_class.call(FakeRequest.new("GET", "/events"), response)

      expect(response.status).to eq(200)
      expect(response["Content-Type"]).to eq("application/json")
      expect(response["Access-Control-Allow-Origin"]).to eq("*")
      expect(JSON.parse(response.body)).to eq([row])
    end
  end
end
