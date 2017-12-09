defmodule StrawHat.Mailer.Schema.TemplatePartial do
  @moduledoc """
  Represents a TemplatePartial Ecto Schema relation.
  """

  use StrawHat.Mailer.Schema
  alias StrawHat.Mailer.Schema.{Template, Partial}

  @typedoc """
  - ***template_id:*** The `template_id` is a reference to templates schema.
  - ***partial_id:*** The `partial_id` is a reference to partials schema.
  """
  @type t :: %__MODULE__{
    template_id: Integer.t,
    partial_id: Integer.t
  }

  @typedoc """
  Check `t` type for more information about the keys.
  """
  @type template_partial_attrs :: %{
    template_id: Integer.t,
    partial_id: Integer.t
  }

  @required_fields ~w(template_id partial_id)a

  @primary_key false
  schema "template_partial" do
    belongs_to(:template, Template)
    belongs_to(:partial, Partial)
  end

  @doc """
  Validate the attributes and return a Ecto.Changeset for the current Template Partial.
  """
  @spec changeset(t, template_partial_attrs) :: Ecto.Changeset.t
  def changeset(template_partial, template_partial_attrs) do
    template_partial
    |> cast(template_partial_attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
