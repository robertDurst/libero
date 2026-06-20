# Stand-ins for the WEBrick request/response objects that Vercel's Ruby
# runtime passes to the handler.
class FakeRequest
  attr_reader :request_method

  def initialize(request_method)
    @request_method = request_method
  end
end

class FakeResponse
  attr_accessor :status, :body

  def initialize
    @headers = {}
  end

  def []=(key, value)
    @headers[key] = value
  end

  def [](key)
    @headers[key]
  end
end
