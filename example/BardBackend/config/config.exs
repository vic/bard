# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :bard_backend, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:bard_backend, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :bard_backend, BardBackend.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  render_errors: [view: BardBackend.ErrorView, accepts: ~w[json]],
  pubsub: [name: BardBackend.PubSub,
           adapter: Phoenix.PubSub.PG2],
  http: [port: 4000],
  url: [host: "localhost", port: 4000],
  secret_key_base: "ITDofrt09K04kIyp7F5FJVHRTLuPjiRDlt0U1owtIzz2K93K1YiUM0EfyGjQzhFL",
  watchers: [npm: ["start",
                    cd: Path.expand("../../BardWeb", __DIR__)]]

config :bard_backend,
  namespace: BardBackend

config :phoenix, :stacktrace_depth, 20
