module Libero
  # Permissive CORS support for the browser-facing endpoints.
  module CORS
    HEADERS = {
      "Access-Control-Allow-Origin" => "*",
      "Access-Control-Allow-Methods" => "GET, OPTIONS",
      "Access-Control-Allow-Headers" => "Content-Type"
    }.freeze

    # Stamp the CORS headers onto a WEBrick-style response.
    def self.apply(response)
      HEADERS.each { |key, value| response[key] = value }
      response
    end

    # Is this request a CORS preflight (OPTIONS) probe?
    def self.preflight?(request)
      request.respond_to?(:request_method) && request.request_method == "OPTIONS"
    end
  end
end
