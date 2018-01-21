defmodule StrawHat.Mailer.Schema.Template do
  @moduledoc """
  Represents a Template Ecto Schema with functionality about the data validation
  for Template.
  """

  use StrawHat.Mailer.Schema
  alias StrawHat.Mailer.Schema.{Privacy, TemplatePartial, Partial}

  @typedoc """
  - ***name:*** unique identifier (per owner_id) of the template.
  - ***title:*** Human readable title.
  - ***privacy:*** Check `t:StrawHat.Mailer.Schema.Privacy.t/0` for more information.
  - ***owner_id:*** Check `t:StrawHat.Mailer.owner_id/0` for more information.
  - ***subject:*** The subject of the email. You can use Mustache template
  inside for render dynamic content from the data pass to the template.
  - ***pre_header:*** The `pre_header` of the email. You can use Mustache
  template inside for render dynamic html content from the data pass to the template.
  - ***html:*** The `html` of the email. You can use Mustache
  template inside for render dynamic html content from the data pass to the template.
  - ***text:*** The `text` of the email. You can use Mustach
  template inside for render dynamic html content from the data pass to the template.
  """
  @type t :: %__MODULE__{
          name: String.t(),
          title: String.t(),
          subject: String.t(),
          owner_id: StrawHat.Mailer.owner_id(),
          privacy: Privacy.t(),
          pre_header: String.t(),
          html: String.t(),
          text: String.t()
        }

  @typedoc """
  Check `t` type for more information about the keys.
  """
  @type template_attrs :: %{
          name: String.t(),
          title: String.t(),
          subject: String.t(),
          owner_id: StrawHat.Mailer.owner_id(),
          privacy: Privacy.t(),
          pre_body: String.t(),
          html: String.t(),
          text: String.t()
        }

  @required_fields ~w(name title subject owner_id)a
  @optional_fields ~w(pre_header html text privacy)a
  @name_regex ~r/^[a-z]+[a-z_]+[a-z]$/

  schema "templates" do
    field(:name, :string)
    field(:title, :string)
    field(:subject, :string)
    field(:owner_id, :string)
    field(:privacy, Privacy)
    field(:pre_header, :string)
    field(:html, :string)
    field(:text, :string)

    many_to_many(
      :partials,
      Partial,
      join_through: TemplatePartial,
      on_replace: :delete,
      on_delete: :delete_all,
      unique: true
    )
  end

  @doc """
  Validate the attributes and return a Ecto.Changeset for the current Template.
  """
  @spec changeset(t, template_attrs) :: Ecto.Changeset.t()
  def changeset(template, template_attrs) do
    template
    |> cast(template_attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> update_change(:title, &String.trim/1)
    |> validate_inclusion(:privacy, Privacy.values())
    |> validate_name()
  end

  defp validate_name(changeset) do
    changeset
    |> update_change(:name, &cleanup_name/1)
    |> validate_format(:name, @name_regex)
    |> unique_constraint(:name, name: :templates_owner_id_name_index)
  end

  defp cleanup_name(name) do
    name
    |> String.trim()
    |> String.replace(~r/\s/, "_")
    |> String.downcase()
  end
end
