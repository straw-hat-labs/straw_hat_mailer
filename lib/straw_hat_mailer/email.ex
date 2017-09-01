defmodule StrawHat.Mailer.Email do
  import Swoosh.Email

  alias StrawHat.Mailer.Template

  defdelegate to(email, recipient), to: Swoosh.Email

  def template(name, options) do
    case Template.template(name) do
      {:error, _reason} -> new()
      {:ok, template} ->
        new()
        |> from({template.from.name, template.from.email})
        |> add_subject(template, options)
        |> add_html(template, options)
        |> add_text(template, options)
    end
  end

  defp add_subject(email, template, options) do
    case template.subject do
      nil -> email
      subject ->
        subject = replace_options(subject, options)
        subject(email, subject)
    end
  end

  defp add_html(email, template, options) do
    case template.html_body do
      nil  -> email
      html ->
        html = replace_options(html, options)
        html_body(email, html)
    end
  end

  defp add_text(email, template, options) do
    case template.text_body do
      nil  -> email
      text ->
        text = replace_options(text, options)
        text_body(email, text)
    end
  end

  defp replace_options(text, options) do
    Enum.reduce(options, text, fn({key, value}, acc) ->
      if is_binary(key) || is_number(key),
        do: String.replace(acc, "{#{key}}", value), else: acc
    end)
  end
end
