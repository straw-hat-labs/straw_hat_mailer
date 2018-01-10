defmodule StrawHat.Mailer do
  @moduledoc """
  Check `Swoosh.Mailer` documentation for learn more about this module.
  """
  use Swoosh.Mailer, otp_app: :straw_hat_mailer

  @typedoc """
  The identifier of the owner. We recommend to use combinations
  of `system + resource id`. For example: `"system_name:resource_id"` or any other
  combination. The reason behind is that if you use just some resource id,
  example just `"1"`, you can't use more than one resource that owns the
  template with the same `id`.
  """
  @type owner_id :: String.t()

  @doc """
  Send an email asynchronous.

  It use `StrawHat.Mailer.deliver/1` inside `Task.start/1`.
  """
  @spec deliver_later(Swoosh.Email.t(), keyword) :: {:ok, pid}
  def deliver_later(email, config \\ []) do
    Task.start(fn -> deliver(email, config) end)
  end
end
