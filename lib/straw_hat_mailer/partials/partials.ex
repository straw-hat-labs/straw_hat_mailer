defmodule StrawHat.Mailer.Partials do
  @moduledoc """
  Defines functionality for partial management.

  A Partial is just a chunk of email content that you could reuse
  cross multiple emails.
  """

  use StrawHat.Mailer.Interactor

  alias StrawHat.Mailer.Partial

  @doc """
  Get the list of partials.
  """
  @spec get_partials(Scrivener.Config.t()) :: Scrivener.Page.t()
  def get_partials(pagination \\ []), do: Repo.paginate(Partial, pagination)

  @doc """
  Create a partial.
  """
  @spec create_partial(Partial.partial_attrs()) ::
          {:ok, Partial.t()} | {:error, Ecto.Changeset.t()}
  def create_partial(partial_attrs) do
    %Partial{}
    |> Partial.changeset(partial_attrs)
    |> Repo.insert()
  end

  @doc """
  Update a partial.
  """
  @spec update_partial(Partial.t(), Partial.partial_attrs()) ::
          {:ok, Partial.t()} | {:error, Ecto.Changeset.t()}
  def update_partial(%Partial{} = partial, partial_attrs) do
    partial
    |> Partial.changeset(partial_attrs)
    |> Repo.update()
  end

  @doc """
  Destroy a partial.
  """
  @spec destroy_partial(Partial.t()) :: {:ok, Partial.t()} | {:error, Ecto.Changeset.t()}
  def destroy_partial(%Partial{} = partial), do: Repo.delete(partial)

  @doc """
  Get a partial by `id`.
  """
  @spec find_partial(String.t()) :: {:ok, Partial.t()} | {:error, Error.t()}
  def find_partial(partial_id) do
    case get_partial(partial_id) do
      nil ->
        error =
          Error.new("straw_hat_mailer.partial.not_found", metadata: [partial_id: partial_id])

        {:error, error}

      partial ->
        {:ok, partial}
    end
  end

  @doc """
  Get a partial by `id`.
  """
  @spec get_partial(String.t()) :: Partial.t() | nil | no_return
  def get_partial(partial_id), do: Repo.get(Partial, partial_id)

  @doc """
  Get the list of partials by `owner_id`.
  """
  @spec get_owner_partials(String.t(), Scrivener.Config.t()) :: Scrivener.Page.t()
  def get_owner_partials(owner_id, pagination \\ []) do
    owner_id
    |> partials_by_owner()
    |> Repo.paginate(pagination)
  end

  @spec partials_by_owner(String.t()) :: Ecto.Query.t()
  defp partials_by_owner(owner_id) do
    from(partial in Partial, where: partial.owner_id == ^owner_id)
  end
end
