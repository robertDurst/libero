module Libero
  # The /health endpoint — a readiness check. Where /status is a liveness
  # probe that always reports "ok" (the process is up), this only passes when
  # a real round-trip to the database succeeds, so load balancers can tell
  # "running" apart from "running but can't reach its data".
  module Health
    OK = "ok".freeze
    UNHEALTHY = "unhealthy".freeze

    def self.call(_request, response)
      if DB.healthy?
        Responses.text(response, 200, OK)
      else
        Responses.text(response, 503, UNHEALTHY)
      end
    end
  end
end
