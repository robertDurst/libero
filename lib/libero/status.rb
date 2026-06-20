module Libero
  # The /status health-check endpoint. The router handles preflight and
  # method/path checks, so this only renders the happy-path body.
  module Status
    BODY = "ok".freeze

    def self.call(_request, response)
      Responses.text(response, 200, BODY)
    end
  end
end
