# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sudoku,
  ecto_repos: [Sudoku.Repo]

# Configures the endpoint
config :sudoku, SudokuWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PNZRl4/WFXg1UnL9HqHRkBwbsFPVYno0sSuA8WSDTQNeWW7Xtgk7rPPn3116b6s0",
  render_errors: [view: SudokuWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Sudoku.PubSub,
  live_view: [signing_salt: "59GUelsK"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
