use Mix.Config

config :straw_hat_mailer, ecto_repos: [StrawHat.Mailer.Repo]

config :straw_hat_mailer, StrawHat.Mailer.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "straw_hat_mailer_test",
  username: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :straw_hat_mailer, StrawHat.Mailer, adapter: Swoosh.Adapters.Local

config :swoosh, preview_port: 5000

config :logger, level: :warn
