defmodule StrawHat.Mailer.Email do
  @moduledoc """
  Add capability to create emails using templates.

  ```elixir
  token = get_token()
  from = {"ACME", "noreply@acme.com"}
  to = {"Straw Hat Team", "some_email@acme.com"}
  data = %{
    confirmation_token: token
  }

  {:ok, email} =
    from
    |> StrawHat.Mailer.Email.new(to)
    |> StrawHat.Mailer.Email.with_template("welcome", data)

  StrawHat.Mailer.deliver(email)
  ```
  """

  use StrawHat.Mailer.Interactor

  alias Swoosh.Email
  alias StrawHat.Mailer.Template
  alias StrawHat.Mailer.Schema.Template, as: TemplateSchema

  @typedoc """
  The tuple is compose by the name and email.

  Example: `{"Straw Hat Team", "straw_hat_team@straw_hat.com"}`
  """
  @type address :: {String.t(), String.t()}

  @typedoc """
  Recipient or list of recipients of the email.
  """
  @type to :: address | [address]

  @typep email_body_type :: :html | :text

  @doc """
  Create a `Swoosh.Email` struct. It use `Swoosh.Email.new/1` so you can check
  the Swoosh documentation, the only different is this one force you to pass
  `from` and `to` as paramters rather than inside the `opts`.
  """
  @spec new(address, to, keyword) :: Email.t()
  def new(from, to, opts \\ []) do
    opts
    |> Keyword.merge(to: to, from: from)
    |> Email.new()
  end

  @doc """
  Add `subject`, `html_body` and `text_body` to the Email using a template.
  """
  @spec with_template(Email.t(), TemplateSchema.t() | String.t(), map) ::
          {:ok, Email.t()} | {:error, Error.t()}
  def with_template(email, template_name_or_template_schema, data \\ %{})

  def with_template(email, %TemplateSchema{} = template, data) do
    email =
      email
      |> add_subject(template.subject, data)
      |> add_body(:html, template, data)
      |> add_body(:text, template, data)

    {:ok, email}
  end

  def with_template(email, template_name, data) do
    case Template.get_template_by_name(template_name) do
      {:error, reason} -> {:error, reason}
      {:ok, template} -> with_template(email, template, data)
    end
  end

  @spec add_subject(Email.t(), String.t(), map) :: Email.t()
  defp add_subject(email, subject, data) do
    subject = Mustache.render(subject, data)
    Email.subject(email, subject)
  end

  @spec add_body(Email.t(), email_body_type(), TemplateSchema.t(), map) :: Email.t()
  defp add_body(email, type, template, data) do
    template_data =
      %{data: data}
      |> put_pre_header(type, template)
      |> put_partials(type, template)

    body =
      type
      |> get_body_by_type(template)
      |> Mustache.render(template_data)

    add_body_to_email(type, email, body)
  end

  @spec put_pre_header(map(), email_body_type(), TemplateSchema.t()) :: map()
  defp put_pre_header(template_data, type, template) do
    pre_header = render_pre_header(template, template_data)

    case type do
      :text ->
        Map.put(template_data, :pre_header, pre_header)

      :html ->
        Map.put(
          template_data,
          :pre_header_html,
          "<span style=\"display: none !important;\">#{pre_header}</span>"
        )
    end
  end

  @spec put_partials(map(), email_body_type(), TemplateSchema.t()) :: map()
  defp put_partials(template_data, type, template) do
    partials = render_partials(type, template, template_data)
    Map.put(template_data, :partials, partials)
  end

  @spec get_body_by_type(email_body_type(), TemplateSchema.t()) :: String.t()
  defp get_body_by_type(:html, template), do: template.html_body
  defp get_body_by_type(:text, template), do: template.text_body

  @spec add_body_to_email(email_body_type(), TemplateSchema.t(), String.t()) :: Email.t()
  defp add_body_to_email(:html, email, body), do: Email.html_body(email, body)
  defp add_body_to_email(:text, email, body), do: Email.text_body(email, body)

  @spec render_partials(email_body_type(), TemplateSchema.t(), map()) :: map()
  defp render_partials(type, template, template_data) do
    Enum.reduce(template.partials, %{}, fn partial, reducer_accumulator ->
      name = Map.get(partial, :name)

      content =
        partial
        |> Map.get(type)
        |> Mustache.render(template_data)

      Map.put(reducer_accumulator, String.to_atom(name), content)
    end)
  end

  @spec render_pre_header(TemplateSchema.t(), map()) :: String.t()
  defp render_pre_header(%TemplateSchema{pre_header: nil} = _template, _template_data) do
    ""
  end

  @spec render_pre_header(TemplateSchema.t(), map()) :: String.t()
  defp render_pre_header(%TemplateSchema{pre_header: pre_header} = _template, template_data) do
    Mustache.render(pre_header, template_data)
  end
end
