defmodule StrawHat.Mailer.Schema.TemplatePartial do
  @moduledoc """
  Represents a TemplatePartial Ecto Schema relation.
  """

  use StrawHat.Mailer.Schema
  alias StrawHat.Mailer.Schema.{Template, Partial}

  @typedoc """
  - **template_id:** The `template_id` is a reference to templates schema.
  - **partial_id:** The `partial_id` is a reference to partials schema.
  """
  @type t :: %__MODULE__{
          template_id: Integer.t(),
          partial_id: Integer.t()
        }

  @typedoc """
  Check `t` type for more information about the keys.
  """
  @type template_partial_attrs :: %{
          template_id: Integer.t(),
          partial_id: Integer.t()
        }

  schema "template_partials" do
    belongs_to(:template, Template)
    belongs_to(:partial, Partial)
  end

  @doc """
  Validate the attributes and return a Ecto.Changeset for the current Template Partial.
  """
  @spec changeset(t, Template.t(), Partial.t(), map()) :: Ecto.Changeset.t()
  def changeset(template_partial, template, partial, params \\ %{}) do
    template_partial
    |> cast(params, [])
    |> unique_constraint(:partial, name: :template_partials_template_id_partial_id_index)
    |> put_assoc(:template, template)
    |> put_assoc(:partial, partial)
  end
end
