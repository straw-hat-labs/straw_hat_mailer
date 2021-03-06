defmodule StrawHat.Mailer.Emails do
  @moduledoc """
  Adds capability to create emails using templates.

      from = {"ACME", "noreply@acme.com"}
      to = {"Straw Hat Team", "some_email@acme.com"}
      data = %{
        "confirmation_token" => "12345"
      }
      email = StrawHat.Mailer.Email.new(from, to)
      {:ok, email} = StrawHat.Mailer.Email.with_template(MyRepo, email, "confirmation_email", data)

      StrawHat.Mailer.deliver_later(email)

  All your templates will receive the same shape of data which you could use
  mustache syntax for using it, read about `t:StrawHat.Mailer.Email.template_data/0`.
  """

  alias Swoosh.Email
  alias StrawHat.Response
  alias StrawHat.Mailer.{Templates, TemplateEngine, Template}

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

  Example:

      {"Straw Hat Team", "straw_hat_team@straw_hat.com"}
  """
  @type address :: {String.t(), String.t()}

  @typedoc """
  Recipient or list of recipients of the email.
  """
  @type to :: address | [address]

  @doc """
  Creates a `Swoosh.Email` struct. It use `Swoosh.Email.new/1` so you can check
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
  Adds `subject`, `html` and `text` to the Email using a template.
  """
  @spec with_template(Email.t(), Template.t(), map) ::
          {:ok, Email.t()} | {:error, Error.t()}
  def with_template(email, %Template{} = template, data) do
    email
    |> add_subject(template.subject, data)
    |> add_body(template, data)
    |> Response.ok()
  end

  @doc """
  Adds `subject`, `html` and `text` to the Email using a template.
  """
  @spec with_template(Ecto.Repo.t(), Email.t(), String.t(), map) ::
          {:ok, Email.t()} | {:error, Error.t()}
  def with_template(repo, email, template_name, data) do
    repo
    |> Templates.get_template_by_name(template_name)
    |> Response.and_then(&with_template(email, &1, data))
  end

  defp add_subject(email, subject, data) do
    subject = TemplateEngine.render(subject, data)
    Email.subject(email, subject)
  end

  defp add_body(email, template, data) do
    template_data =
      %{"data" => data}
      |> put_pre_header(template)
      |> put_partials(template)

    html = render_body(:html, template, template_data)
    text = render_body(:text, template, template_data)

    email
    |> add_body_to_email(:html, html)
    |> add_body_to_email(:text, text)
  end

  defp render_body(type, template, template_data) do
    partial_from_type =
      template_data
      |> Map.get("partials")
      |> Map.get(type)

    template_data = Map.put(template_data, "partials", partial_from_type)

    type
    |> get_body_by_type(template)
    |> TemplateEngine.render(template_data)
  end

  defp put_pre_header(template_data, template) do
    pre_header = render_pre_header(template, template_data)

    template_data
    |> Map.put("pre_header", pre_header)
    |> Map.put(
      "pre_header_html",
      "<span style=\"display: none !important;\">#{pre_header}</span>"
    )
  end

  defp put_partials(template_data, template) do
    partials = render_partials(template, template_data)
    Map.put(template_data, "partials", partials)
  end

  defp get_body_by_type(:html, template), do: template.html
  defp get_body_by_type(:text, template), do: template.text

  defp add_body_to_email(email, :html, body), do: Email.html_body(email, body)
  defp add_body_to_email(email, :text, body), do: Email.text_body(email, body)

  defp render_partials(template, template_data) do
    template
    |> Map.get(:partials)
    |> Enum.reduce(%{html: %{}, text: %{}}, fn partial, reducer_accumulator ->
      name = Map.get(partial, :name)
      html = render_partial(:html, name, partial, reducer_accumulator, template_data)
      text = render_partial(:text, name, partial, reducer_accumulator, template_data)
      %{html: html, text: text}
    end)
  end

  defp render_partial(type, name, partial, partials_data, template_data) do
    rendered_partial =
      partial
      |> Map.get(type)
      |> TemplateEngine.render(template_data)

    partials_data
    |> Map.get(type)
    |> Map.put(name, rendered_partial)
  end

  defp render_pre_header(%Template{pre_header: nil} = _template, _template_data) do
    ""
  end

  defp render_pre_header(%Template{pre_header: pre_header} = _template, template_data) do
    TemplateEngine.render(pre_header, template_data)
  end
end
