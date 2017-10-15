defmodule StrawHat.Mailer.Email do
  alias Swoosh.Email
  alias StrawHat.Mailer.Template

  @typedoc """
  The tuple is compose by the name and email.

  Example: `{"Straw Hat Team", "straw_hat_team@straw_hat.com"}`
  """
  @type address :: {String.t, String.t}
  @type to :: address | [address]

  @doc """
  Create a Swoosh.Email struct. It use Swoosh.Email.new/1 so you can check
  the Swoosh documentation, the only different is this one force you to pass
  from and to as paramters rather than inside the opts.
  """
  @spec new(to, address, keyword) :: Swoosh.Email.t
  def new(to, from, opts \\ []) do
    opts
    |> Keyword.merge([to: to, from: from])
    |> Email.new()
  end

  @doc """
  Add `subject` and `html_body` to the Email using a template.
  """
  @spec with_template(Swoosh.Email.t, String.t, map) :: Swoosh.Email.t
  def with_template(email, template_name, data) do
    case Template.get_template_by_name(template_name) do
      {:error, _reason} -> email
      {:ok, template} ->
        email
        |> add_subject(template.subject, data)
        |> add_html_body(template.html_body, data)
    end
  end

  defdelegate send_email(email), to: StrawHat.Mailer, as: :deliver

  @doc """
  Send an email async using Task.
  """
  @spec send_email_later(Swoosh.Email.t) :: {:ok, pid}
  def send_email_later(email) do
    Task.start(fn -> send_email(email) end)
  end

  defp add_subject(email, subject, opts) do
    subject = Mustache.render(subject, opts)
    Email.subject(email, subject)
  end

  defp add_html_body(email, html_body, opts) do
    html_body = Mustache.render(html_body, opts)
    Email.html_body(email, html_body)
  end
end
