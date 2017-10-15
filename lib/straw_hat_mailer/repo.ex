defmodule StrawHat.Mailer.Repo do
  @moduledoc """
  Check Ecto.Repo documentation for learn more about the module. This is
  an extension of that module.
  """
  use Ecto.Repo, otp_app: :straw_hat_mailer
  use Scrivener, page_size: 25
end
