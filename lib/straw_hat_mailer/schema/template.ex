defmodule StrawHat.Mailer.Schema.Template do
  use Ecto.Schema
  import Ecto.Changeset

  alias StrawHat.Mailer.Schema.Template.From

  @required_fields ~w(name service subject text_body)a
  @optional_fields ~w(html_body)a

  schema "templates" do
    field(:name, :string)
    field(:service, :string)
    field(:subject, :string)
    field(:text_body, :string)
    field(:html_body, :string)
    embeds_one(:from, From)
  end

  def changeset(template, params \\ %{}) do
    template
    |> cast(params, @required_fields ++ @optional_fields)
    |> cast_embed(:from)
    |> validate_required(@required_fields)
    |> unique_constraint(:name, name: :templates_name_index)
  end
end
