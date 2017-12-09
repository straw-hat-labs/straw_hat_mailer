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

  alias Swoosh.Email
  alias StrawHat.Mailer.Template

  @typedoc """
  The tuple is compose by the name and email.

  Example: `{"Straw Hat Team", "straw_hat_team@straw_hat.com"}`
  """
  @type address :: {String.t(), String.t()}
  @type to :: address | [address]

  @doc """
  Create a `Swoosh.Email` struct. It use `Swoosh.Email.new/1` so you can check
  the Swoosh documentation, the only different is this one force you to pass
  `from` and `to` as paramters rather than inside the `opts`.
  """
  @spec new(address, to, keyword) :: Swoosh.Email.t()
  def new(from, to, opts \\ []) do
    opts
    |> Keyword.merge(to: to, from: from)
    |> Email.new()
  end

  @doc """
  Add `subject` and `html_body` or `text_body` to the Email using a template.
  """
  @spec with_template(Swoosh.Email.t(), String.t(), map) :: Swoosh.Email.t()
  def with_template(email, template_name, data) do
    case Template.get_template_by_name(template_name) do
      {:error, _reason} ->
        email

      {:ok, template} ->
        email
        |> add_subject(template.subject, data)
        |> add_body(:html, template, data)
        |> add_body(:text, template, data)
    end
  end

  defp add_subject(email, subject, data) do
    subject = Mustache.render(subject, data)
    Email.subject(email, subject)
  end

  defp add_body(email, type, template, data) do
    data = add_partials_to_data(type, template, data)

    pre_header = render_pre_header(template, data)
    content =
      type
      |> get_content_by_type(template)
      |> Mustache.render(data)

    data = %{
      pre_header: pre_header,
      content: content
    }
    body = render_markup(data)
    render_body(type, email, body)
  end

  defp get_content_by_type(:html, template), do: template.html_body
  defp get_content_by_type(:text, template), do: template.text_body

  defp render_body(:html, email, body), do: Email.html_body(email, body)
  defp render_body(:text, email, body), do: Email.text_body(email, body)

  defp add_partials_to_data(content_type, template, data) do
    Enum.reduce(template.partials, data, fn(partial, data) ->
      key = Map.get(partial, :key)
      content =
        partial
        |> Map.get(content_type)
        |> Mustache.render(data)
      Map.put(data, key, content)
    end)
  end

  defp render_pre_header(template, data) do
    case template.pre_header do
      nil -> ""
      pre_header ->
        text = Mustache.render(pre_header, data)
        '<span style="display: none !important;">#{text}</span>'
    end
  end

  defp render_markup(data) do
    markup = "{{pre_header}} {{content}}"
    Mustache.render(markup, data)
  end
end
