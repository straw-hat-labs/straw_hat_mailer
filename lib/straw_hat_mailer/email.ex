defmodule StrawHat.Mailer.Email do
  import Swoosh.Email

  alias Mustache
  alias StrawHat.Mailer.Template

  def new_email(email) do
    case email[:template] do
      nil -> new(email)
      name -> 
        options = get_options(email)
        email
        |> Enum.filter(fn({key, _}) -> not key in [:template, :options] end)
        |> create_email_with_template(name, options)
    end
  end

  def create_email_with_template(email, template_name, options) do
    case Template.get_template_by_name(template_name) do
      {:error, _reason} -> new(email)
      {:ok, template} ->
        email
        |> add_subject(template.subject, options)
        |> add_html_body(template.html_body, options)
        |> add_text_body(template.text_body, options)
        |> new()
    end
  end

  defdelegate send(email), to: StrawHat.Mailer, as: :deliver

  def send_later(email) do
    Task.start(fn ->
      send(email)
    end)
  end

  defp get_options(email) do
    with nil <- email[:options], do: %{}
  end

  defp add_subject(email, subject, options) do
    subject = render(subject, options)
    Enum.concat(email, [subject: subject])
  end

  defp add_html_body(email, html_body, options) do
    html_body = render(html_body, options)
    Enum.concat(email, [html_body: html_body])
  end

  defp add_text_body(email, text_body, options) do
    text_body = render(text_body, options)
    Enum.concat(email, [text_body: text_body])
  end

  defp render(template, options), do: Mustache.render(template, options)
end
