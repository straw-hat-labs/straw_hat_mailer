defmodule StrawHat.Mailer do
  @moduledoc """
  Check Swoosh.Mailer documentation for learn more about the module. This is
  an extension of that module.
  """
  use Swoosh.Mailer, otp_app: :straw_hat_mailer


  @doc """
  Send an email asynchronous.
  """
  @spec deliver_later(Swoosh.Email.t) :: {:ok, pid}
  def deliver_later(email) do
    Task.start(fn -> deliver(email) end)
  end
end
