# Vercel Ruby serverless function.
# Reachable at /status via the rewrite in vercel.json.
Handler = proc do |request, response|
  # Allow cross-origin browser requests.
  response["Access-Control-Allow-Origin"] = "*"
  response["Access-Control-Allow-Methods"] = "GET, OPTIONS"
  response["Access-Control-Allow-Headers"] = "Content-Type"

  if request.respond_to?(:request_method) && request.request_method == "OPTIONS"
    # CORS preflight request — no body needed.
    response.status = 204
    response.body = ""
  else
    response.status = 200
    response["Content-Type"] = "text/plain"
    response.body = "ok"
  end
end
