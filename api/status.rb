# Vercel Ruby serverless function.
# Reachable at /status via the rewrite in vercel.json.
require_relative "../lib/libero"

Handler = proc do |request, response|
  Libero::Status.call(request, response)
end
