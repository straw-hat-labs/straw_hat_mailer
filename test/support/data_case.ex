defmodule StrawHat.Mailer.Test.DataCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Query

      import StrawHat.Mailer.Test.DataCase
      import StrawHat.Mailer.Test.Factory

      alias StrawHat.Mailer.Repo
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(StrawHat.Mailer.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(StrawHat.Mailer.Repo, {:shared, self()})
    end

    :ok
  end
end
