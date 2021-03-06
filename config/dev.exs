use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :echo, Echo.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
               cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :echo, Echo.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20


config :echo, Echo,
  valid_cors_domains: ["http://fms.dev.rednovalabs.net"]

config :echo, Echo.Google,
  client_id: "729002142760-04tsuh7hav6demmova0vpmhkdl0ahd47.apps.googleusercontent.com",
  client_secret: "uF7VeT_BObOj2jXUaAu504aP",
  redirect_uri: "http://localhost:4000/auth/google/callback"

import_config "dev.secret.exs"
