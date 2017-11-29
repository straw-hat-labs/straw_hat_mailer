defmodule StrawHat.Mailer.Schema.Partial do
  @moduledoc """
  Represents a Partial Ecto Schema with functionality about the data validation
  for Partial Template.
  """

  use StrawHat.Mailer.Schema
  alias StrawHat.Mailer.Template.Privacy

  @typedoc """
  - ***html_header:*** The `html_header` is a Mustach template or plain text that is
  combined with `html_body` of the email.
  - ***html_footer:***  The `html_footer` is a Mustach template or plain text that is
  combined with `html_body` of the email.
  - ***text_header:*** The `text_header` is a Mustach template or plain text that is
  combined with `text_body` of the email.
  - ***text_footer:***  The `text_footer` is a Mustach template or plain text that is
  combined with `text_body` of the email.
  - ***owner_id:*** The identifier of the owner. We recommend to use combinations
  of `system + resource id`. For example: `"system_name:resource_id"` or any other
  combination. The reason behind is that if you use just some resource id,
  example just `"1"`, you can't use more than one resource that owns the
  template with the same `id`.
  """
  @type t :: %__MODULE__{
    html_header: String.t,
    html_footer: String.t,
    text_header: String.t,
    text_footer: String.t,
    privacy: Privacy.t,
    owner_id: String.t
  }

  @typedoc """
  Check `t` type for more information about the keys.
  """
  @type partial_attrs :: %{
    html_header: String.t,
    html_footer: String.t,
    text_header: String.t,
    text_footer: String.t,
    privacy: Privacy.t,
    owner_id: String.t,
  }

  @required_fields ~w(html_header text_header html_footer text_footer privacy owner_id)a

  schema "partials" do
    field(:html_header, :string)
    field(:html_footer, :string)
    field(:text_header, :string)
    field(:text_footer, :string)
    field(:privacy, Privacy)
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
    |> validate_inclusion(:privacy, Privacy.values())
  end
end
