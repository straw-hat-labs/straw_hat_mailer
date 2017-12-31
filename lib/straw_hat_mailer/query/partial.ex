defmodule StrawHat.Mailer.Query.PartialQuery do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias StrawHat.Mailer.Schema.{Partial, Privacy}

  @spec by_owner(String.t()) :: Ecto.Query.t()
  def by_owner(owner_id) do
    from(partial in Partial, where: partial.owner_id == ^owner_id)
  end

  @spec include_public(Ecto.Query.t(), boolean()) :: Ecto.Query.t()
  def include_public(query, true) do
    from(partial in query, or_where: partial.privacy == ^Privacy.public())
  end

  def include_public(query, _), do: query
end
