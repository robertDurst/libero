require "active_record"

module Libero
  # ActiveRecord connection bootstrap.
  #
  # Vercel reuses a warm serverless instance across many invocations, so we
  # establish the connection pool once per instance and reuse it. Point
  # DATABASE_URL at Neon's pooled (-pooler) connection string so PgBouncer
  # fans the (small) pool out across functions.
  module DB
    # Raised when DATABASE_URL is missing — surfaced rather than swallowed so
    # a misconfigured deploy fails loudly instead of looking merely unhealthy.
    class NotConfigured < StandardError; end

    # Establish the AR connection pool, once per warm instance. Idempotent:
    # later calls are a cheap no-op. A serverless function handles one request
    # at a time, so a tiny pool is plenty.
    def self.connect!
      return if @connected

      url = ENV["DATABASE_URL"]
      raise NotConfigured, "DATABASE_URL is not set" if url.nil? || url.empty?

      ActiveRecord::Base.establish_connection(url)
      @connected = true
    end

    # A trivial round-trip to Postgres. Returns a boolean (never raises) so
    # the /health endpoint can branch on it; a failure tears the pool down so
    # the next call reconnects from scratch (an idle pooler eventually drops
    # us).
    def self.healthy?
      connect!
      ActiveRecord::Base.connection.execute("SELECT 1")
      true
    rescue StandardError
      reset!
      false
    end

    # Discard the connection pool. Disconnecting can itself fail on an already
    # broken socket, which is fine — we're throwing it away regardless.
    def self.reset!
      ActiveRecord::Base.connection_handler.clear_all_connections!
    rescue StandardError
      nil
    ensure
      @connected = false
    end
  end
end
