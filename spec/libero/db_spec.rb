RSpec.describe Libero::DB do
  after { described_class.instance_variable_set(:@connected, nil) }

  describe ".connect!" do
    it "raises NotConfigured when DATABASE_URL is unset" do
      stub_const("ENV", ENV.to_h.tap { |env| env.delete("DATABASE_URL") })

      expect { described_class.connect! }.to raise_error(Libero::DB::NotConfigured)
    end

    it "raises NotConfigured when DATABASE_URL is blank" do
      stub_const("ENV", ENV.to_h.merge("DATABASE_URL" => ""))

      expect { described_class.connect! }.to raise_error(Libero::DB::NotConfigured)
    end

    it "establishes the pool once across repeated calls" do
      stub_const("ENV", ENV.to_h.merge("DATABASE_URL" => "postgres://localhost/test"))
      expect(ActiveRecord::Base).to receive(:establish_connection).once.with("postgres://localhost/test")

      described_class.connect!
      described_class.connect!
    end
  end

  describe ".healthy?" do
    before { allow(described_class).to receive(:connect!) }

    it "is true when the round-trip succeeds" do
      conn = double("connection")
      allow(ActiveRecord::Base).to receive(:connection).and_return(conn)
      expect(conn).to receive(:execute).with("SELECT 1")

      expect(described_class.healthy?).to be(true)
    end

    it "is false and resets the pool when the round-trip fails" do
      allow(ActiveRecord::Base).to receive(:connection).and_raise(StandardError)
      expect(described_class).to receive(:reset!)

      expect(described_class.healthy?).to be(false)
    end
  end
end
