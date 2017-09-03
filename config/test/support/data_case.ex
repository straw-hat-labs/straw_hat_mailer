defmodule IAMTest.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import IAMTest.DataCase

      import IAMTest.Factory
      alias StrawHat.IAM.Repo
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(StrawHat.IAM.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(StrawHat.IAM.Repo, {:shared, self()})
    end

    :ok
  end
end
