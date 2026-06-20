module Libero
  # The /events endpoint — the calendar/schedule the frontend renders.
  # Returns a JSON array sorted by date then time, shaped to match what the
  # page already expects: { date, time, title, location, type }.
  module Events
    # The schedule as an array of row hashes, ready to serialise. Lives here
    # so bin/console can call Events.all too.
    def self.all
      DB.connect!
      CalendarEvent.ordered.map(&:as_event)
    end

    def self.call(_request, response)
      Responses.json(response, 200, all)
    end
  end
end
