source "https://rubygems.org"

# Postgres driver. Point DATABASE_URL at Neon's pooled (-pooler) connection
# string so the serverless functions share the PgBouncer pool.
gem "pg", "~> 1.5"

# ORM + migrations. `require: "active_record"` so Bundler.require-less loads
# still get the right path; we require it explicitly in lib/libero/db.rb.
gem "activerecord", "~> 8.0", require: "active_record"

group :test do
  gem "rspec", "~> 3.13"
end
