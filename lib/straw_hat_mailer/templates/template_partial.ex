defmodule StrawHat.Mailer.TemplatePartial do
  @moduledoc """
  Represents a TemplatePartial Ecto Schema relation.
  """

  use StrawHat.Mailer.Schema
  alias StrawHat.Mailer.{Template, Partial}

  @typedoc """
  - `template`: `t:StrawHat.Mailer.Template.t/0` associated with the
  template partial.
  - `template_id`: `id` of `t:StrawHat.Mailer.Template.t/0` associated
  with the template partial.
  - `partial`: `t:StrawHat.Mailer.Partial.t/0` associated with the
  template partial.
  - `partial_id`: `id` of `t:StrawHat.Mailer.Partial.t/0` associated
  with the template partial.
  """
  @type t :: %__MODULE__{
          template: Template.t() | Ecto.Association.NotLoaded.t(),
          template_id: Integer.t(),
          partial: Partial.t() | Ecto.Association.NotLoaded.t(),
          partial_id: Integer.t()
        }

  @typedoc """
  Check `t:t/0` type for more information about the keys.
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
  Validates the attributes and return a Ecto.Changeset for the current Template Partial.
  """
  @since "1.0.0"
  @spec changeset(t, Template.t(), Partial.t(), map()) :: Ecto.Changeset.t()
  def changeset(template_partial, template, partial, params \\ %{}) do
    template_partial
    |> cast(params, [])
    |> unique_constraint(:partial, name: :template_partials_template_id_partial_id_index)
    |> put_assoc(:template, template)
    |> put_assoc(:partial, partial)
  end
end
