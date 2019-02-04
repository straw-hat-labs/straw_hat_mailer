defmodule StrawHat.Mailer.Partials do
  @moduledoc """
  Partials management use cases.

  A Partial is just a chunk of email content that you could reuse cross multiple
  emails. This is useful when you want to share sections between email
  templates.
  """

  import Ecto.Query
  alias StrawHat.{Error, Response}
  alias StrawHat.Mailer.Partial

  @spec get_partials(Ecto.Repo.t(), Scrivener.Config.t()) :: Scrivener.Page.t()
  def get_partials(repo, pagination \\ []) do
    Scrivener.paginate(Partial, Scrivener.Config.new(repo, [], pagination))
  end

  @spec create_partial(Ecto.Repo.t(), Partial.partial_attrs()) ::
          Response.t(Partial.t(), Ecto.Changeset.t())
  def create_partial(repo, partial_attrs) do
    %Partial{}
    |> Partial.changeset(partial_attrs)
    |> repo.insert()
    |> Response.from_value()
  end

  @spec update_partial(Ecto.Repo.t(), Partial.t(), Partial.partial_attrs()) ::
          Response.t(Partial.t(), Ecto.Changeset.t())
  def update_partial(repo, %Partial{} = partial, partial_attrs) do
    partial
    |> Partial.changeset(partial_attrs)
    |> repo.update()
    |> Response.from_value()
  end

  @spec destroy_partial(Ecto.Repo.t(), Partial.t()) :: Response.t(Partial.t(), Ecto.Changeset.t())
  def destroy_partial(repo, %Partial{} = partial) do
    partial
    |> repo.delete()
    |> Response.from_value()
  end

  @spec find_partial(Ecto.Repo.t(), String.t()) :: Response.t(Partial.t(), Ecto.Changeset.t())
  def find_partial(repo, partial_id) do
    repo
    |> get_partial(partial_id)
    |> Response.from_value(
      Error.new("straw_hat_mailer.partial.not_found", metadata: [partial_id: partial_id])
    )
  end

  @spec get_partial(Ecto.Repo.t(), String.t()) :: Partial.t() | nil | no_return
  def get_partial(repo, partial_id) do
    repo.get(Partial, partial_id)
  end

  @spec change_partial(Partial.t()) :: Ecto.Changeset.t()
  def change_partial(%Partial{} = partial) do
    Partial.changeset(partial, %{})
  end

  @doc """
  Returns a list of partials that belongs to the `owner_id`.
  """
  @since "1.0.0"
  @spec get_owner_partials(Ecto.Repo.t(), String.t(), Scrivener.Config.t()) :: Scrivener.Page.t()
  def get_owner_partials(repo, owner_id, pagination \\ []) do
    Partial
    |> select([partial], partial)
    |> where(owner_id: ^owner_id)
    |> Scrivener.paginate(Scrivener.Config.new(repo, [], pagination))
  end
end
