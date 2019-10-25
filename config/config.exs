# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ladder,
  ecto_repos: [Ladder.Repo]

# Configures the endpoint
config :ladder, LadderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VBkzpQKTmXvACVNJTy+akIQ0CsRxsDGm3FZQrXkhTnjrEKih/lnjgXTEv8rOKWWz",
  render_errors: [view: LadderWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ladder.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
