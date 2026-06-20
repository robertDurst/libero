# Vercel Ruby serverless function — the single entrypoint for all traffic.
# vercel.json rewrites every path here; Libero.routes does the dispatching.
require_relative "../lib/libero"

Handler = proc do |request, response|
  Libero.routes.call(request, response)
end
