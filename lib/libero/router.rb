module Libero
  # A tiny request router. Maps (method, path) pairs to endpoints and owns
  # the cross-cutting responses: CORS preflight, 404 (unrouted path) and
  # 405 (known path, wrong method).
  class Router
    Route = Struct.new(:method, :path, :endpoint)

    def initialize
      @routes = []
    end

    # Register a GET endpoint. Returns self so registrations can chain.
    def get(path, &endpoint)
      @routes << Route.new("GET", path, endpoint)
      self
    end

    def call(request, response)
      # Answer any CORS preflight uniformly, before path matching.
      return Responses.no_content(response) if CORS.preflight?(request)

      path = request_path(request)
      for_path = @routes.select { |route| route.path == path }
      return Responses.not_found(response) if for_path.empty?

      route = for_path.find { |r| r.method == request_method(request) }
      return method_not_allowed(response, for_path) unless route

      route.endpoint.call(request, response)
    end

    private

    def method_not_allowed(response, for_path)
      allow = (for_path.map(&:method) + ["OPTIONS"]).uniq.join(", ")
      Responses.method_not_allowed(response, allow)
    end

    def request_method(request)
      request.respond_to?(:request_method) ? request.request_method : "GET"
    end

    def request_path(request)
      request.respond_to?(:path) ? request.path : "/"
    end
  end
end
