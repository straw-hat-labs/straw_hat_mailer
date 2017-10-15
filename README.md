# StrawHat.Mailer

Email Management with templating capability. The templates use Mustache template
under the hood so you can do everything that the template system allow you to do.

## Installation

```elixir
def deps do
  [{:straw_hat_mailer, ">= 0.1.2"}]
end
```

## Usage

StrawHat.Mailer use Swoosh under the hood. The next example shows how to create an email using specific template.

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
