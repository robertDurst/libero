module Libero
  VERSION = "0.1.0"

  # The /version endpoint — reports the running library version.
  module Version
    def self.call(_request, response)
      Responses.text(response, 200, Libero::VERSION)
    end
  end
end
