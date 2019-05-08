# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :acqdat,
  ecto_repos: [Acqdat.Repo]

# Configures the endpoint
config :acqdat, AcqdatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DSFWWliDy/7qz8QSbZIbYredF5qiUZHlUKNJ29m85HIFSCXyfyInuvm2hktYCvs8",
  render_errors: [view: AcqdatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Acqdat.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure Guardian
config :acqdat, AcqdatWeb.Guardian,
  issuer: "acqdat",
  secret_key: "CaTqqe1yk8ofdh1Cmn8Oh9yOiaVYw06rsjnJWMBqoIMw+w4wnFweNkWAoyeWsjK9"

config :acqdat, AcqdatWeb.AuthenticationPipe,
  module: AcqdatWeb.Guardian,
  error_handler: AcqdatWeb.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
