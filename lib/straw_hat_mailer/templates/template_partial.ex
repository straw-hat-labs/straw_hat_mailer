defmodule StrawHat.Mailer.TemplatePartial do
  @moduledoc """
  Template's Partial entity.
  """

  use StrawHat.Mailer.Schema
  alias StrawHat.Mailer.{Template, Partial}

  @type t :: %__MODULE__{
          template: Template.t() | Ecto.Association.NotLoaded.t(),
          template_id: Integer.t(),
          partial: Partial.t() | Ecto.Association.NotLoaded.t(),
          partial_id: Integer.t()
        }

  @type template_partial_attrs :: %{
          template_id: Integer.t(),
          partial_id: Integer.t()
        }

  schema "template_partials" do
    belongs_to(:template, Template)
    belongs_to(:partial, Partial)
    timestamps()
  end

  @spec changeset(t, Template.t(), Partial.t(), map()) :: Ecto.Changeset.t()
  def changeset(template_partial, template, partial, params \\ %{}) do
    template_partial
    |> cast(params, [])
    |> unique_constraint(:partial, name: :template_partials_template_id_partial_id_index)
    |> put_assoc(:template, template)
    |> put_assoc(:partial, partial)
  end
end
