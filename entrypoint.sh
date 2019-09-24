#!/bin/sh
# Docker entrypoint script.

# Wait until Postgres is ready
while ! pg_isready -q -h $DB_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

./prod/rel/acqdat/bin/acqdat eval Acqdat.Release.migrate
./prod/rel/acqdat/bin/acqdat eval Acqdat.ReleaseTasks.seed
./prod/rel/acqdat/bin/acqdat start
