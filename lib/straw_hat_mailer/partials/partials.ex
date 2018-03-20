defmodule StrawHat.Mailer.Partials do
  @moduledoc """
  Defines functionality for partial management.

  A Partial is just a chunk of email content that you could reuse
  cross multiple emails.
  """

  use StrawHat.Mailer.Interactor
  alias StrawHat.Mailer.Partial

  @doc """
  Returns the list of partials.
  """
  @since "1.0.0"
  @spec get_partials(Scrivener.Config.t()) :: Scrivener.Page.t()
  def get_partials(pagination \\ []), do: Repo.paginate(Partial, pagination)

  @doc """
  Creates a partial.
  """
  @since "1.0.0"
  @spec create_partial(Partial.partial_attrs()) ::
          {:ok, Partial.t()} | {:error, Ecto.Changeset.t()}
  def create_partial(partial_attrs) do
    %Partial{}
    |> Partial.changeset(partial_attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a partial.
  """
  @since "1.0.0"
  @spec update_partial(Partial.t(), Partial.partial_attrs()) ::
          {:ok, Partial.t()} | {:error, Ecto.Changeset.t()}
  def update_partial(%Partial{} = partial, partial_attrs) do
    partial
    |> Partial.changeset(partial_attrs)
    |> Repo.update()
  end

  @doc """
  Destroys a partial.
  """
  @since "1.0.0"
  @spec destroy_partial(Partial.t()) :: {:ok, Partial.t()} | {:error, Ecto.Changeset.t()}
  def destroy_partial(%Partial{} = partial), do: Repo.delete(partial)

  @doc """
  Get a partial by `id`.
  """
  @since "1.0.0"
  @spec find_partial(String.t()) :: {:ok, Partial.t()} | {:error, Error.t()}
  def find_partial(partial_id) do
    partial_id
    |> get_partial()
    |> StrawHat.Response.from_value(
      Error.new("straw_hat_mailer.partial.not_found", metadata: [partial_id: partial_id])
    )
  end

  @doc """
  Get a partial by `id`.
  """
  @since "1.0.0"
  @spec get_partial(String.t()) :: Partial.t() | nil | no_return
  def get_partial(partial_id), do: Repo.get(Partial, partial_id)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking partial changes.
  """
  @since "1.0.0"
  @spec change_partial(Partial.t()) :: Ecto.Changeset.t()
  def change_partial(%Partial{} = partial) do
    Partial.changeset(partial, %{})
  end

  @doc """
  Returns a list of partials that belongs to the `owner_id`.
  """
  @since "1.0.0"
  @spec get_owner_partials(String.t(), Scrivener.Config.t()) :: Scrivener.Page.t()
  def get_owner_partials(owner_id, pagination \\ []) do
    owner_id
    |> partials_by_owner()
    |> Repo.paginate(pagination)
  end

  @since "1.0.0"
  @spec partials_by_owner(String.t()) :: Ecto.Query.t()
  defp partials_by_owner(owner_id) do
    from(partial in Partial, where: partial.owner_id == ^owner_id)
  end
end
