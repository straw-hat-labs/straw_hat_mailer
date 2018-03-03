defmodule StrawHat.Mailer.Email do
  @moduledoc """
  Add capability to create emails using templates.

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

  All your templates will receive the same shape of data which you could use
  mustache syntax for using it, read about `t:StrawHat.Mailer.Email.template_data/0`.
  """

  use StrawHat.Mailer.Interactor

  alias Swoosh.Email
  alias StrawHat.Mailer.{Template, TemplateEngine}
  alias StrawHat.Mailer.Schema.Template, as: TemplateSchema

  @typedoc """
  You would use the data as mustache syntax does it using brackets.
  The `partials` key will whole all the partials of your template using
  `name as the key` so you will be able to use it as `{{{partials.PARTIAL_NAME}}}`.
  Notice I am using triple brackets and that is because probably you want to
  escape the output.
  """
  @type template_data :: %{
          data: struct(),
          partials: %{
            required(atom()) => String.t()
          },
          pre_header: String.t(),
          pre_header_html: String.t()
        }

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
  Add `subject`, `html` and `text` to the Email using a template.
  """
  @spec with_template(Email.t(), TemplateSchema.t() | String.t(), map) ::
          {:ok, Email.t()} | {:error, Error.t()}
  def with_template(email, template_name_or_template_schema, data \\ %{})

  def with_template(email, %TemplateSchema{} = template, data) do
    email =
      email
      |> add_subject(template.subject, data)
      |> add_body(template, data)

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
    subject = TemplateEngine.render(subject, data)
    Email.subject(email, subject)
  end

  @spec add_body(Email.t(), TemplateSchema.t(), map) :: Email.t()
  defp add_body(email, template, data) do
    template_data =
      %{data: data}
      |> put_pre_header(template)
      |> put_partials(template)

    html = render_body(:html, template, template_data)
    text = render_body(:text, template, template_data)

    email
    |> add_body_to_email(:html, html)
    |> add_body_to_email(:text, text)
  end

  @spec render_body(email_body_type(), TemplateSchema.t(), map()) :: map()
  defp render_body(type, template, template_data) do
    partial_type = Map.get(template_data.partials, type)
    template_data = Map.put(template_data, :partials, partial_type)

    type
    |> get_body_by_type(template)
    |> TemplateEngine.render(template_data)
  end

  @spec put_pre_header(map(), TemplateSchema.t()) :: map()
  defp put_pre_header(template_data, template) do
    pre_header = render_pre_header(template, template_data)

    template_data
    |> Map.put(:pre_header, pre_header)
    |> Map.put(:pre_header_html, "<span style=\"display: none !important;\">#{pre_header}</span>")
  end

  @spec put_partials(map(), TemplateSchema.t()) :: map()
  defp put_partials(template_data, template) do
    partials = render_partials(template, template_data)
    Map.put(template_data, :partials, partials)
  end

  @spec get_body_by_type(email_body_type(), TemplateSchema.t()) :: String.t()
  defp get_body_by_type(:html, template), do: template.html
  defp get_body_by_type(:text, template), do: template.text

  @spec add_body_to_email(Email.t(), email_body_type(), String.t()) :: Email.t()
  defp add_body_to_email(email, :html, body), do: Email.html_body(email, body)
  defp add_body_to_email(email, :text, body), do: Email.text_body(email, body)

  @spec render_partials(TemplateSchema.t(), map()) :: map()
  defp render_partials(template, template_data) do
    Enum.reduce(template.partials, %{html: %{}, text: %{}}, fn partial, reducer_accumulator ->
      name = Map.get(partial, :name)
      html = add_partial(:html, name, partial, reducer_accumulator, template_data)
      text = add_partial(:text, name, partial, reducer_accumulator, template_data)
      %{html: html, text: text}
    end)
  end

  @spec add_partial(email_body_type(), String.t(), map(), map(), map()) :: map()
  defp add_partial(type, name, partial, partials_data, template_data) do
    render_partial =
      partial
      |> Map.get(type)
      |> TemplateEngine.render(template_data)

    partials_data
    |> Map.get(type)
    |> Map.put(String.to_atom(name), render_partial)
  end

  @spec render_pre_header(TemplateSchema.t(), map()) :: String.t()
  defp render_pre_header(%TemplateSchema{pre_header: nil} = _template, _template_data) do
    ""
  end

  @spec render_pre_header(TemplateSchema.t(), map()) :: String.t()
  defp render_pre_header(%TemplateSchema{pre_header: pre_header} = _template, template_data) do
    TemplateEngine.render(pre_header, template_data)
  end
end
