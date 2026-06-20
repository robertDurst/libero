RSpec.describe Libero::DB do
  after { described_class.instance_variable_set(:@connection, nil) }

  describe ".connection" do
    it "raises NotConfigured when DATABASE_URL is unset" do
      stub_const("ENV", ENV.to_h.tap { |env| env.delete("DATABASE_URL") })

      expect { described_class.connection }.to raise_error(Libero::DB::NotConfigured)
    end

    it "raises NotConfigured when DATABASE_URL is blank" do
      stub_const("ENV", ENV.to_h.merge("DATABASE_URL" => ""))

      expect { described_class.connection }.to raise_error(Libero::DB::NotConfigured)
    end
  end

  describe ".healthy?" do
    it "is true when the round-trip succeeds" do
      conn = double("connection")
      allow(described_class).to receive(:connection).and_return(conn)
      expect(conn).to receive(:exec).with("SELECT 1")

      expect(described_class.healthy?).to be(true)
    end

    it "is false and resets the connection when the round-trip fails" do
      allow(described_class).to receive(:connection).and_raise(StandardError)
      expect(described_class).to receive(:reset!)

      expect(described_class.healthy?).to be(false)
    end
  end
end
