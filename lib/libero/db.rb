module Libero
  # Thin wrapper around the Postgres connection.
  #
  # Vercel reuses a warm serverless instance across many invocations, so we
  # memoize one connection per instance and reconnect only when the socket
  # has died (an idle pooler will eventually drop us). Point DATABASE_URL at
  # Neon's pooled (-pooler) connection string so PgBouncer fans these out.
  module DB
    # Raised when DATABASE_URL is missing — surfaced rather than swallowed so
    # a misconfigured deploy fails loudly instead of looking merely unhealthy.
    class NotConfigured < StandardError; end

    # The memoized connection for this instance, reconnecting if it has gone
    # away. `pg` is required lazily so the rest of the library loads (and the
    # suite runs) even where the native gem isn't built.
    def self.connection
      url = ENV["DATABASE_URL"]
      raise NotConfigured, "DATABASE_URL is not set" if url.nil? || url.empty?

      require "pg"
      return @connection if @connection && !@connection.finished?

      @connection = PG.connect(url)
    end

    # A trivial round-trip to Postgres. Returns a boolean (never raises) so
    # the /health endpoint can branch on it; a failure drops the connection
    # so the next call reconnects from scratch.
    def self.healthy?
      connection.exec("SELECT 1")
      true
    rescue StandardError
      reset!
      false
    end

    # Discard the memoized connection. Closing can itself fail on an already
    # broken socket, which is fine — we're throwing it away regardless.
    def self.reset!
      @connection&.close
    rescue StandardError
      nil
    ensure
      @connection = nil
    end
  end
end
