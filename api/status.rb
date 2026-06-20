# Vercel Ruby serverless function.
# Reachable at /status via the rewrite in vercel.json.
Handler = proc do |_request, response|
  response.status = 200
  response["Content-Type"] = "text/plain"
  response.body = "ok"
end
