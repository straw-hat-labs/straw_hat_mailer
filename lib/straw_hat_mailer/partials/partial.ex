defmodule StrawHat.Mailer.Partial do
  @moduledoc """
  Represents a Partial Ecto Schema with functionality about the data validation
  for Partial Template.
  """

  use StrawHat.Mailer.Schema
  alias StrawHat.Mailer.Privacy

  @typedoc """
  - `title`: Human readable title.
  - `name`: The partial identificator and is used for index the rendered
  content of partial in the template body.
  - `html`: The `html` is a Mustache template that will be used when you call
  the partial on your template.
  - `text`: The `text` is a Mustache template that will be used when you call
  the partial on your template.
  - `privacy`: Check `t:StrawHat.Mailer.Privacy.t/0` for more information.
  - `owner_id`: Check `t:StrawHat.Mailer.owner_id/0` for more information.
  """
  @type t :: %__MODULE__{
          name: String.t(),
          title: String.t(),
          html: String.t(),
          text: String.t(),
          privacy: Privacy.t(),
          owner_id: StrawHat.Mailer.owner_id()
        }

  @typedoc """
  Check `t:t/0` type for more information about the keys.
  """
  @type partial_attrs :: %{
          name: String.t(),
          title: String.t(),
          html: String.t(),
          text: String.t(),
          privacy: Privacy.t(),
          owner_id: String.t()
        }

  @required_fields ~w(name title owner_id)a
  @optional_fields ~w(html text privacy)a
  @name_regex ~r/^[a-z]+[a-z_]+[a-z]$/

  schema "partials" do
    field(:title, :string)
    field(:name, :string)
    field(:html, :string)
    field(:text, :string)
    field(:privacy, Privacy)
    field(:owner_id, :string)
  end

  @doc """
  Validates the attributes and return a Ecto.Changeset for the current Partial Template.
  """
  @spec changeset(t, partial_attrs) :: Ecto.Changeset.t()
  def changeset(partial, partial_attrs) do
    partial
    |> cast(partial_attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> update_change(:title, &String.trim/1)
    |> validate_inclusion(:privacy, Privacy.values())
    |> validate_name()
  end

  @spec validate_name(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_name(changeset) do
    changeset
    |> update_change(:name, &cleanup_name/1)
    |> validate_format(:name, @name_regex)
    |> unique_constraint(:name, name: :partials_owner_id_name_index)
  end

  @spec cleanup_name(String.t()) :: String.t()
  defp cleanup_name(name) do
    name
    |> String.trim()
    |> String.replace(~r/\s/, "_")
    |> String.downcase()
  end
end
