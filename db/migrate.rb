# Migration CLI over the ActiveRecord migrations in db/migrate/*.rb.
# Applied versions are tracked in schema_migrations, so everything is
# re-runnable. Reach it through bin/migrate:
#
#   bin/migrate                # apply everything pending (up to latest)
#   bin/migrate up             #   "
#   bin/migrate down [N]       # roll back the last N migrations (default 1)
#   bin/migrate rollback [N]   # alias of `down`
#   bin/migrate redo [N]       # roll back N then re-apply them
#   bin/migrate to VERSION     # migrate up or down to an exact version (0 = empty)
#   bin/migrate status         # list every migration and whether it's up/down
#   bin/migrate version        # print the current schema version
#
# All commands take DATABASE_URL from the environment.
require_relative "../lib/libero"

Libero::DB.connect!
ActiveRecord::Migration.verbose = true

context = ActiveRecord::MigrationContext.new(File.expand_path("migrate", __dir__))
# `migrate` creates the bookkeeping tables itself, but read-only commands
# (status/version) query them, so ensure they exist on a pristine database.
context.schema_migration.create_table
context.internal_metadata.create_table

command, arg = ARGV
steps = arg ? Integer(arg) : 1

case command
when nil, "up"
  context.migrate
when "down", "rollback"
  context.rollback(steps)
when "redo"
  context.rollback(steps)
  context.migrate
when "to"
  abort "usage: bin/migrate to VERSION" unless arg
  context.migrate(Integer(arg))
when "status"
  puts "\n status   version   migration"
  puts "-" * 48
  context.migrations_status.each do |status, version, name|
    puts format("   %-4s    %-7s   %s", status, version, name)
  end
  puts
when "version"
  # falls through to the summary line below
else
  abort "unknown command: #{command} " \
        "(use up | down [N] | rollback [N] | redo [N] | to VERSION | status | version)"
end

puts "schema at version #{context.current_version}" unless command == "status"
