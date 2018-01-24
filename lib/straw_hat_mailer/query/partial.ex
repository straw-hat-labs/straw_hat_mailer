defmodule StrawHat.Mailer.Query.PartialQuery do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias StrawHat.Mailer.Schema.Partial

  @spec by_owner(String.t()) :: Ecto.Query.t()
  def by_owner(owner_id) do
    from(partial in Partial, where: partial.owner_id == ^owner_id)
  end
end
