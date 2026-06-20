module Libero
  # A calendar/schedule event — the rows the frontend renders and reads over
  # HTTP from GET /events. The table is `calendar_events` (AR drops the module
  # prefix). `type` here is a plain free-text column (Liga, Champions, ...),
  # NOT single-table inheritance, so we switch STI off.
  class CalendarEvent < ActiveRecord::Base
    self.inheritance_column = nil

    # Sort key for the page: by day, then time, with timeless entries (NULL)
    # ahead of timed ones on the same day.
    scope :ordered, -> {
      order(:event_date).order(Arel.sql("event_time ASC NULLS FIRST"))
    }

    # The shape the page expects: string keys, NULLs flattened to "" so the
    # consumer never has to null-check.
    def as_event
      {
        "date" => event_date.strftime("%Y-%m-%d"),
        "time" => event_time.to_s,
        "title" => title.to_s,
        "location" => location.to_s,
        "type" => type.to_s,
      }
    end
  end
end
