defmodule StrawHat.Mailer do
  @moduledoc """
  Check `Swoosh.Mailer` documentation for learn more about this module.
  """
  use Swoosh.Mailer, otp_app: :straw_hat_mailer

  @doc """
  Send an email asynchronous.

  It use `StrawHat.Mailer.deliver/1` inside `Task.start/1`.
  """
  @spec deliver_later(Swoosh.Email.t(), keyword) :: {:ok, pid}
  def deliver_later(email, config \\ []) do
    Task.start(fn -> deliver(email, config) end)
  end
end
