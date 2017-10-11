defmodule StrawHat.Mailer.Email do
  import Swoosh.Email

  alias StrawHat.Mailer.Template

  def new_email(to, from, opts \\ %{}) do
    opts
    |> Map.merge(%{to: to, from: from})
    |> new()
  end

  def with_template(email, template_name, opts) do
    case Template.get_template_by_name(template_name) do
      {:error, _reason} -> email
      {:ok, template} ->
        email
        |> add_subject(template.subject, opts)
        |> add_html_body(template.html_body, opts)
    end
  end

  defdelegate send_email(email), to: StrawHat.Mailer, as: :deliver

  def send_email_later(email) do
    Task.start(fn -> send_email(email) end)
  end

  defp add_subject(email, subject, opts) do
    subject = Mustache.render(subject, opts)
    Map.put(email, :subject, subject)
  end

  defp add_html_body(email, html_body, opts) do
    html_body = Mustache.render(html_body, opts)
    Map.put(email, :html_body, html_body)
  end

  defp add_text_body(email, text_body, opts) do
    text_body = Mustache.render(text_body, opts)
    Map.put(email, :text_body, text_body)
  end
end
