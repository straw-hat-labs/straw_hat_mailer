defmodule StrawHat.Mailer.TestSupport.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :straw_hat_mailer,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 25
end
