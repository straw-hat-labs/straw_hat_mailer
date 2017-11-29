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
  Add `subject` and `html_body` to the Email using a template.
  """
  @spec with_template(Swoosh.Email.t(), String.t(), map) :: Swoosh.Email.t()
  def with_template(email, template_name, data) do
    case Template.get_template_by_name(template_name) do
      {:error, _reason} ->
        email

      {:ok, template} ->
        email
        |> add_subject(template.subject, data)
        |> add_body(template, data)
    end
  end

  defp add_subject(email, subject, opts) do
    subject = Mustache.render(subject, opts)
    Email.subject(email, subject)
  end

  defp add_html_body(email, html_body, partial, opts) do
    html_body =
      case partial do
        nil -> Mustache.render(html_body, opts)
        %{header: header, footer: footer} ->
          [header, html_body, footer]
          |> Enum.join("</br>")
          |> Mustache.render(opts)
      end
    Email.html_body(email, html_body)
  end

  defp add_body(email, template, opts) do
     body =
       []
       |> add_pre_header(template)
       |> add_header(template)
       |> add_html(template)
       |> add_text(template)
       |> add_footer(template)
     case template.html_body do
       nil ->
         text_body = render_body(body, opts)
         Email.text_body(email, text_body)
       _ ->
         html_body = render_body(body, opts, "</br>")
         Email.html_body(email, html_body)
     end
  end

  defp render_body(body, opts, separator \\ "\n") do
    body
    |> Enum.reverse()
    |> Enum.join(separator)
    |> Mustache.render(opts)
  end

  defp add_pre_header(body, template) do
    case template.pre_header do
      nil -> body
      pre_header -> build_markup(body, template, pre_header)
    end
  end

  defp build_markup(body, template, text) do
    case template.html_body do
      nil -> ['#{text}\n\n' | body]
      _ -> ['<span style="display: none !important;">#{text}</span>' | body]
    end
  end

  defp add_header(body, template) do
    case template.partial do
      nil -> body
      partial -> [partial.header | body]
    end
  end

  defp add_html(body, template) do
    case template.html_body do
      nil -> body
      html_body -> [html_body | body]
    end
  end

  defp add_text(body, template) do
    case template.text_body do
      nil -> body
      text_body -> [text_body | body]
    end
  end

  defp add_footer(body, template) do
    case template.partial do
      nil -> body
      partial -> [partial.footer | body]
    end
  end
end
