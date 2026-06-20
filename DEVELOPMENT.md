# Development

Console:

```sh
DATABASE_URL=postgres://... bin/console
```

Migrate:

```sh
DATABASE_URL=postgres://... bin/migrate            # up to latest
DATABASE_URL=postgres://... bin/migrate down [N]   # roll back last N (default 1)
DATABASE_URL=postgres://... bin/migrate redo [N]   # roll back N then re-apply
DATABASE_URL=postgres://... bin/migrate to VERSION # up/down to an exact version (0 = empty)
DATABASE_URL=postgres://... bin/migrate status     # per-migration up/down state
DATABASE_URL=postgres://... bin/migrate version    # current schema version
```

Seed (calendar/schedule rows from `db/seeds/calendar_events.json`):

```sh
DATABASE_URL=postgres://... bin/seed
```
