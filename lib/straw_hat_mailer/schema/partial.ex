defmodule StrawHat.Mailer.Schema.Partial do
  @moduledoc """
  Represents a Partial Ecto Schema with functionality about the data validation
  for Partial Template.
  """

  use StrawHat.Mailer.Schema

  @typedoc """
  - ***header:*** The `header` is a Mustach template or plain text that is
  combined with `html_body` of the email.
  - ***footer:***  The `footer` is a Mustach template or plain text that is
  combined with `html_body` of the email.
  - ***owner_id:*** The identifier of the owner. We recommend to use combinations
  of `system + resource id`. For example: `"system_name:resource_id"` or any other
  combination. The reason behind is that if you use just some resource id,
  example just `"1"`, you can't use more than one resource that owns the
  template with the same `id`.
  """
  @type t :: %__MODULE__{
    header: String.t,
    footer: String.t,
    owner_id: String.t
  }

  @typedoc """
  Check `t` type for more information about the keys.
  """
  @type partial_attrs :: %{
    header: String.t,
    footer: String.t,
    owner_id: String.t,
  }

  @required_fields ~w(header footer owner_id)a

  schema "partials" do
    field(:header, :string)
    field(:footer, :string)
    field(:owner_id, :string)
  end

  @doc """
  Validate the attributes and return a Ecto.Changeset for the current Partial Template.
  """
  @spec changeset(t, partial_attrs) :: Ecto.Changeset.t
  def changeset(partial, partial_attrs) do
    partial
    |> cast(partial_attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
