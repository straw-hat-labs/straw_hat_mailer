defmodule StrawHat.Mailer.Application do
  @moduledoc false
  
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(StrawHat.Mailer.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: StrawHat.Mailer.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
