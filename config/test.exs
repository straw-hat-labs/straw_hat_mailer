use Mix.Config

config :straw_hat_mailer, StrawHat.Mailer.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "straw_hat_mailer_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :straw_hat_mailer, StrawHat.Mailer.Mailer,
  adapter: Swoosh.Adapters.Local

config :swoosh,
  preview_port: 5000
