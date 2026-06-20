# libero

A tiny Ruby status endpoint, deployed as a Vercel serverless function.

| Method | Path      | Response   |
| ------ | --------- | ---------- |
| `GET`  | `/status` | `200` `ok` |

## Files

- `api/status.rb` — the Vercel function. Returns `200 ok`.
- `vercel.json` — rewrites `/status` to the function.
- `spec/status_spec.rb` — RSpec test for the handler.

## Develop

```sh
bundle install
bundle exec rspec
```

## Deploy to Vercel

Push to GitHub and import the repo on [vercel.com](https://vercel.com) (Hobby plan
is free, no card). Vercel detects the Ruby function in `api/` and serves it — no
build step, no Dockerfile. `GET /status` returns `ok`.
