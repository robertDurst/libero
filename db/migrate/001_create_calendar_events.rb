# Calendar / schedule events. Replaces the schedule that the frontend
# (colchonero.cafe) used to ship as a hardcoded CSV; it now reads these rows
# over HTTP from GET /events.
#
# `event_time` and the descriptive columns are nullable because some entries
# (a draw, a "matchday 1" placeholder) have no kickoff time or venue yet.
# `type` is a plain free-text column (the model disables STI). Times are
# peninsular Spanish (CET/CEST) wall-clock strings, so nothing is shifted
# across a timezone on the way to the page.
class CreateCalendarEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :calendar_events, if_not_exists: true do |t|
      t.date :event_date, null: false
      t.text :event_time
      t.text :title
      t.text :location
      t.text :type
      t.column :created_at, :timestamptz, null: false, default: -> { "now()" }
    end

    # The page lists events in date/time order; index the sort key.
    add_index :calendar_events, [:event_date, :event_time],
              name: "calendar_events_date_idx", if_not_exists: true
  end
end
