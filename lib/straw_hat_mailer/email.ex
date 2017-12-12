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

  defp put_pre_header(template_data, type, template) do
    pre_header = render_pre_header(template, template_data)
    case type do
      :text -> Map.put(template_data, :pre_header, pre_header)
      :html -> Map.put(template_data, :pre_header_html, '<span style="display: none !important;">#{pre_header}</span>')
    end
  end

  defp put_partials(template_data, type, template) do
    partials = render_partials(type, template, template_data)
    Map.put(template_data, :partials, partials)
  end

  defp get_body_by_type(:html, template), do: template.html_body
  defp get_body_by_type(:text, template), do: template.text_body

  defp add_body_to_email(:html, email, body), do: Email.html_body(email, body)
  defp add_body_to_email(:text, email, body), do: Email.text_body(email, body)

  defp render_partials(type, template, data) do
    Enum.reduce(template.partials, %{}, fn(partial, opts) ->
      key = Map.get(partial, :key)
      content =
        partial
        |> Map.get(type)
        |> Mustache.render(data)
      Map.put(opts, String.to_atom(key), content)
    end)
  end

  defp render_pre_header(template, data) do
    case template.pre_header do
      nil -> ""
      pre_header -> Mustache.render(pre_header, data)
    end
  end
end
