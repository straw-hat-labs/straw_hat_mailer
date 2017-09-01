defmodule StrawHat.Mailer.Repo do
  use Ecto.Repo, otp_app: :straw_hat_mailer
  use Scrivener, page_size: 25
end
