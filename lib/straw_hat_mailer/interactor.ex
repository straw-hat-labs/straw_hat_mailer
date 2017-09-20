defmodule StrawHat.Mailer.Interactor do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias StrawHat.Error
      alias StrawHat.Mailer.Repo
    end
  end
end
