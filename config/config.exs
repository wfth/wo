# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wo,
  ecto_repos: [Wo.Repo]

# Configures the endpoint
config :wo, Wo.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dHfS2wZyVda4sl8ngM5BR8E/aogXnjKXgGA8JOVkGHLcy/xCTn65e8XCq37Sxp+Y",
  render_errors: [view: Wo.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Wo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
