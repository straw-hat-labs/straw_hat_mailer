defmodule StrawHat.Mailer do
  @moduledoc """
  This module is an extension of `Swoosh.Mailer`, please read more about
  `Swoosh.Mailer` documentation.

  You can swap the adapter doing the following config:

      config :straw_hat_mailer, StrawHat.Mailer,
        adapter: Swoosh.Adapters.Sendgrid,
        api_key: "SG.x.x"
  """
  use Swoosh.Mailer, otp_app: :straw_hat_mailer

  @typedoc """
  The identifier of the owner. We recommend to use combinations
  of `system + resource id`. For example: `"system_name:resource_id"` or any
  other combination. The reason behind is that if you use just some resource id,
  example just `"1"`, you can't use more than one resource that owns the
  template with the same `id`.
  """
  @type owner_id :: String.t()

  @doc """
  Send an email asynchronous.
  """
  @spec deliver_later(Swoosh.Email.t(), keyword) :: {:ok, pid}
  def deliver_later(email, config \\ []) do
    Task.start(fn -> deliver(email, config) end)
  end
end
