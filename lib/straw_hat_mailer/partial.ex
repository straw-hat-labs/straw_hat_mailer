defmodule StrawHat.Mailer.Partial do
  @moduledoc """
  Interactor module that defines all the functionality for partial management.
  """

  alias StrawHat.Error
  alias StrawHat.Mailer.Repo
  alias StrawHat.Mailer.Schema.Partial

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
  @spec get_partial(String.t()) :: Ecto.Schema.t() | nil | no_return
  def get_partial(partial_id), do: Repo.get(Partial, partial_id)

  @doc """
  Get a partial by `owner_id`.
  """
  @spec get_partial_by_owner(String.t()) :: {:ok, Partial.t()} | {:error, Ecto.Changeset.t()}
  def get_partial_by_owner(owner_id) do
    clauses = [owner_id: owner_id]

    case Repo.get_by(Partial, clauses) do
      nil ->
        error =
          Error.new("straw_hat_mailer.partial.not_found", metadata: [partial_owner: owner_id])

        {:error, error}

      partial ->
        {:ok, partial}
    end
  end
end
