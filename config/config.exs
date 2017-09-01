use Mix.Config

config :straw_hat_mailer,
  ecto_repos: [StrawHat.Mailer.Repo]

import_config "#{Mix.env}.exs"
