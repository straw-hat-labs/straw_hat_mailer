use Mix.Config

config :straw_hat_mailer, ecto_repos: [StrawHat.Mailer.TestSupport.Repo]

config :straw_hat_mailer, StrawHat.Mailer.TestSupport.Repo,
  database: "straw_hat_mailer_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :straw_hat_mailer, StrawHat.Mailer, adapter: Swoosh.Adapters.Local

config :swoosh, preview_port: 5000

config :logger, level: :warn
