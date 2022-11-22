call mix deps.get --only prod
set MIX_ENV=prod
call mix compile
call mix assets.deploy

REM Build the release and overwrite the existing release directory
call mix release --overwrite

REM Run migrations
set DATABASE_URL=_build/prod/rel/streamy/streamy.db
call _build/prod/rel/streamy/bin/streamy eval "Release.migrate"
