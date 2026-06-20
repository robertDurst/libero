# libero

Fútbol data warehouse and analytics system.

## Environment

| Variable | Required | Description |
| --- | --- | --- |
| `DATABASE_URL` | yes | Postgres connection string. Use the **pooled** (`-pooler`) URL from Neon so the serverless functions share PgBouncer, e.g. `postgres://user:pass@ep-xxx-pooler.region.aws.neon.tech/dbname?sslmode=require`. |

Set it locally for the migration/console, and in Vercel under **Project → Settings → Environment Variables** for the deployed functions.

## Database

```sh
# apply the schema (idempotent)
DATABASE_URL=postgres://... bin/migrate

# open an IRB session with the library + a live DB connection (`db`) loaded
DATABASE_URL=postgres://... bin/console
```

`GET /health` is a readiness check: it returns `200 ok` only when a live
round-trip to the database succeeds, and `503 unhealthy` otherwise.
(`GET /status` stays a plain liveness check that the process is up.)
