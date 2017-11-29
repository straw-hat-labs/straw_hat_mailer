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
        |> add_body(template, data)
    end
  end

  defp add_subject(email, subject, data) do
    subject = Mustache.render(subject, data)
    Email.subject(email, subject)
  end

  defp add_body(email, template, data) do
     case template.html_body do
       nil -> add_text_body(email, template, data)
       _   -> add_html_body(email, template, data)
     end
  end

  defp add_html_body(email, template, data) do
    body =
      []
      |> add_pre_header(template)
      |> add_partial(:html_header, template)
      |> add_body_template(:html_body, template)
      |> add_partial(:html_footer, template)
    html_body = render_body(body, data, "</br>")
    Email.html_body(email, html_body)
  end

  defp add_text_body(email, template, data) do
    body =
      []
      |> add_pre_header(template)
      |> add_partial(:text_header, template)
      |> add_body_template(:text_body, template)
      |> add_partial(:text_footer, template)
    text_body = render_body(body, data, "\n")
    Email.text_body(email, text_body)
  end

  defp render_body(body, data, separator) do
    body
    |> Enum.reverse()
    |> Enum.join(separator)
    |> Mustache.render(data)
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

  defp add_partial(body, tag, template) do
    case template.partial do
      nil -> body
      partial -> [Map.get(partial, tag)| body]
    end
  end

  defp add_body_template(body, tag, template) do
    case Map.get(template, tag) do
      nil -> body
      tag_body -> [tag_body | body]
    end
  end
end
