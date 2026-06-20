require "json"

module Libero
  # Builders for the small set of responses our endpoints return.
  # Each one stamps CORS headers and returns the response for convenience.
  module Responses
    def self.text(response, status, body, content_type: "text/plain", headers: {})
      CORS.apply(response)
      response.status = status
      response["Content-Type"] = content_type
      headers.each { |key, value| response[key] = value }
      response.body = body
      response
    end

    # Serialises `data` (an already-built Ruby Array/Hash/...) to a JSON body,
    # keeping endpoints ignorant of the wire format.
    def self.json(response, status, data, headers: {})
      text(response, status, JSON.generate(data),
           content_type: "application/json", headers: headers)
    end

    def self.no_content(response)
      CORS.apply(response)
      response.status = 204
      response.body = ""
      response
    end

    def self.not_found(response)
      text(response, 404, "not found")
    end

    def self.method_not_allowed(response, allow)
      text(response, 405, "method not allowed", headers: { "Allow" => allow })
    end
  end
end
