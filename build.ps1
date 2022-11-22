mix deps.get --only prod
$env:MIX_ENV = "prod"
mix compile
mix assets.deploy

# Build the release and overwrite the existing release directory
mix release --overwrite

# Run migrations
$env:DATABASE_URL = "_build/prod/rel/streamy/streamy.db"
_build/prod/rel/streamy/bin/streamy eval "Release.migrate"
