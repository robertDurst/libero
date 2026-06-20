module Libero
  # The application's route table. Add new endpoints here.
  def self.routes
    @routes ||= Router.new
      .get("/status") { |request, response| Status.call(request, response) }
      .get("/health") { |request, response| Health.call(request, response) }
      .get("/version") { |request, response| Version.call(request, response) }
  end
end
