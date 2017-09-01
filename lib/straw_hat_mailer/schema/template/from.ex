defmodule StrawHat.Mailer.Schema.Template.From do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(name email)a

  embedded_schema do
    field(:name, :string)
    field(:email, :string)
  end

  def changeset(from, params \\ %{}) do
    from
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
