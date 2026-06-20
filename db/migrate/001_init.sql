-- Starter schema for the fútbol warehouse. Kept idempotent (IF NOT EXISTS)
-- so `ruby db/migrate.rb` can be re-run safely.

CREATE TABLE IF NOT EXISTS competitions (
  id          BIGINT PRIMARY KEY,
  name        TEXT NOT NULL,
  country     TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS teams (
  id          BIGINT PRIMARY KEY,
  name        TEXT NOT NULL,
  short_name  TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS matches (
  id              BIGINT PRIMARY KEY,
  competition_id  BIGINT REFERENCES competitions(id),
  home_team_id    BIGINT REFERENCES teams(id),
  away_team_id    BIGINT REFERENCES teams(id),
  kicked_off_at   TIMESTAMPTZ,
  home_goals      INT,
  away_goals      INT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS matches_competition_idx ON matches (competition_id);
CREATE INDEX IF NOT EXISTS matches_kicked_off_idx ON matches (kicked_off_at);
