# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
npm run deploy --prefix ./assets
mix phx.digest

# Finally run the server
PORT=4001 MIX_ENV=prod DATABASE_URL=none mix phx.server