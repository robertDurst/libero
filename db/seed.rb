# Seeds calendar_events from db/seeds/calendar_events.json against DATABASE_URL.
# The seed file is the source of truth, so this replaces the table's contents
# wholesale (delete-all + insert in one transaction) and is safe to re-run.
#
#   DATABASE_URL=postgres://... ruby db/seed.rb
require "json"
require_relative "../lib/libero"

Libero::DB.connect!

file = File.expand_path("seeds/calendar_events.json", __dir__)
events = JSON.parse(File.read(file))

# Empty strings in the JSON become SQL NULLs.
nilify = ->(v) { v.nil? || v.empty? ? nil : v }

Libero::CalendarEvent.transaction do
  Libero::CalendarEvent.delete_all
  events.each do |ev|
    Libero::CalendarEvent.create!(
      event_date: ev["date"],
      event_time: nilify.call(ev["time"]),
      title: nilify.call(ev["title"]),
      location: nilify.call(ev["location"]),
      type: nilify.call(ev["type"]),
    )
  end
end

puts "seeded #{Libero::CalendarEvent.count} calendar event(s)"
