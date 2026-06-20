# Applies every db/migrate/*.sql file, in filename order, against DATABASE_URL.
# The files use IF NOT EXISTS, so this is safe to re-run. Usage:
#
#   DATABASE_URL=postgres://... ruby db/migrate.rb
require_relative "../lib/libero"

files = Dir[File.expand_path("migrate/*.sql", __dir__)].sort
conn = Libero::DB.connection

files.each do |file|
  puts "applying #{File.basename(file)}"
  conn.exec(File.read(file))
end

puts "done (#{files.length} file(s))"
