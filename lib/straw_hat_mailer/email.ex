defmodule StrawHat.Mailer.Email do
  import Swoosh.Email

  alias Mustache
  alias StrawHat.Mailer.Template

  defdelegate to(email, recipient), to: Swoosh.Email
  defdelegate from(email, from), to: Swoosh.Email

  def template(name, options) do
    case Template.get_template_by_name(name) do
      {:error, _reason} -> new()
      {:ok, template} ->
        new()
        |> add_subject(template, options)
        |> add_html(template, options)
        |> add_text(template, options)
    end
  end

  defp add_subject(email, template, options) do
    case template.subject do
      nil -> email
      subject ->
        subject = Mustache.render(subject, options)
        subject(email, subject)
    end
  end

  defp add_html(email, template, options) do
    case template.html_body do
      nil  -> email
      html ->
        html = Mustache.render(html, options)
        html_body(email, html)
    end
  end

  defp add_text(email, template, options) do
    case template.text_body do
      nil  -> email
      text ->
        text = Mustache.render(text, options)
        text_body(email, text)
    end
  end
end
