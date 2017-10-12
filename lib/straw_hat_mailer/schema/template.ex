defmodule StrawHat.Mailer.Schema.Template do
  use StrawHat.Mailer.Schema

  alias StrawHat.Mailer.Template.Privacy

  @required_fields ~w(name title subject owner_id)a
  @optional_fields ~w(html_body privacy)a
  @name_regex ~r/^[a-z]+[a-z_]*$/

  schema "templates" do
    field(:name, :string)
    field(:title, :string)
    field(:subject, :string)
    field(:owner_id, :string)
    field(:privacy, Privacy)
    field(:html_body, :string)
  end

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
