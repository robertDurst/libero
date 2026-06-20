module Libero
  # The /status health-check endpoint.
  module Status
    BODY = "ok".freeze

    # Drive a WEBrick-style request/response pair, the way Vercel's Ruby
    # runtime invokes the handler. Returns the response for convenience.
    def self.call(request, response)
      CORS.apply(response)

      if CORS.preflight?(request)
        # Preflight needs only the headers and an empty 204.
        response.status = 204
        response.body = ""
      else
        response.status = 200
        response["Content-Type"] = "text/plain"
        response.body = BODY
      end

      response
    end
  end
end
