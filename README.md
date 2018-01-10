# StrawHat.Mailer

Email Management with templating capability. The templates use Mustache template
under the hood so you can do everything that the template system allow you to do.

## Installation

```elixir
def deps do
  [
    {:straw_hat_mailer, "~> 0.3"}
  ]
end
```

### Configuration

We need to setup `Swoosh` adapter to be able to send the emails and the database
for save the templates.

```elixir
# In your config files
config :straw_hat_mailer, StrawHat.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "SG.x.x"

config :straw_hat_mailer, StrawHat.Mailer.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "straw_hat_mailer",
  hostname: "localhost",
  username: "postgres",
  password: "postgres"
```

## Usage

StrawHat.Mailer use `Swoosh` under the hood. The next example shows how to create
an email using specific template.

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
