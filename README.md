# StrawHat.Mailer

[![Build Status](https://travis-ci.org/straw-hat-team/straw_hat_mailer.svg?branch=master)](https://travis-ci.org/straw-hat-team/straw_hat_mailer)
[![Coverage Status](https://coveralls.io/repos/github/straw-hat-team/straw_hat_mailer/badge.svg?branch=master)](https://coveralls.io/github/straw-hat-team/straw_hat_mailer?branch=master)
[![Inline docs](http://inch-ci.org/github/straw-hat-team/straw_hat_mailer.svg)](http://inch-ci.org/github/straw-hat-team/straw_hat_mailer)

Email Management with templating capability. The templates use Mustache template
under the hood so you can do everything that the template system allow you to do.

## Installation

```elixir
def deps do
  [
    {:swoosh, "~> 0.12"},
    {:straw_hat_mailer, "~> 0.4"}
  ]
end
```

### Configuration

We need to setup `Swoosh` adapter to be able to send the emails and the database
for save the templates.

```elixir
# In your config files
config :straw_hat_mailer, StrawHat.Mailer,
  # Swoosh.Adapters.Local for development
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

### Creating the Templates

`StrawHat.Mailer.Template` have all the functionalities for managing the
templates, so check the module for more information.

You could use `seed.exs` or just use `iex -S mix` for interactive terminal.

```elixir
{:ok, welcome_template} = StrawHat.Mailer.Template.create_template(%{
  name: "welcome",
  owner_id: "system:my_app",
  privacy: StrawHat.Mailer.Schema.Privacy.public(),
  title: "Welcome to My App",

  subject: "Welcome to My App",
  html: """
  <h1>Welcome to My App {{data.full_name}}</h1>
  """,
  text: """
  Welcome to My App {{data.full_name}}
  """
})
```

You could also use partials on your template so you could share sections of
your email template, most of the time you will use this for the header and footer
so it is easier to update at any time your templates without much afford.

Let's create the partials.

```elixir
{:ok, header_partial} = StrawHat.Mailer.Partial.create_partial(%{
  name: "company_header",
  owner_id: "system:my_app",
  privacy: StrawHat.Mailer.Schema.Privacy.public(),

  html: """
   <header>
    <h1>My App</h1>
    <h2>The Tag line</h2>
   </header>
  """,
  text: """
  My header is Awesome
  The Tag line
  """
})

{:ok, footer_partial} = StrawHat.Mailer.Partial.create_partial(%{
  name: "company_footer",
  owner_id: "system:my_app",
  privacy: StrawHat.Mailer.Schema.Privacy.public(),

  html: """
   <footer>
    <p>Contact ACME for bug report BrokeBack</p>
   </footer>
  """,
  text: """
  Contact ACME for bug report BrokeBack
  """
})
```

Now we just need to add the partials to the template.

```elixir
{:ok, welcome_template} =
  StrawHat.Mailer.Template.get_template_by_name("welcome")

StrawHat.Mailer.Template.add_partials(welcome_template, [
  header_partial,
  footer_partial
])
```

Now you can start using your partials in your template.

```elixir
{:ok, welcome_template} =
  StrawHat.Mailer.Template.get_template_by_name("welcome")

StrawHat.Mailer.Template.update_template(welcome_template, %{
  html: """
  {{{partials.company_header}}}
  <h1>Welcome to My App {{data.full_name}}</h1>
  {{{partials.footer_header}}}
  """,
  text: """
  {{{partials.company_header}}}
  Welcome to My App {{data.full_name}}
  {{{partials.footer_header}}}
  """
})
```

And you are good to go.

### Sending the Email

`StrawHat.Mailer` uses `Swoosh` under the hood. The next example shows how to create
an email using specific template.

```elixir
defmodule MyApp do
  def send_welcome_email(to, data) do
    from = {"ACME", "noreply@acme.com"}

    response =
      from
      |> StrawHat.Mailer.Email.new(to)
      |> StrawHat.Mailer.Email.with_template("welcome", data)

    case response do
      {:ok, email} -> StrawHat.Mailer.deliver(email)
      error -> error
    end
  end
end

# Later on
to = {"User Name", "user_email@something.com"}
data = %{
  full_name: "My name is Jeff"
}

MyApp.send_welcome_email(to, data)
```

### Mix Aliases Task and Ecto

If you are using `Ecto` in your application probably you have some mix aliases
if not then just create it.

```elixir
defp aliases do
  [
    "ecto.setup": [
      "ecto.create",
      "ecto.migrate",
      "run priv/repo/seeds.exs"
    ],
    "ecto.reset": [
      "ecto.drop",
      "ecto.setup"
    ],
    "test": ["ecto.create --quiet", "ecto.migrate", "test"]
  ]
end
```

Then add `StrawHat.Mailer.Repo` to the list of ecto repos on your application
in your config.

```elixir
# config/config.exs

config :my_app,
  ecto_repos: [
    # ...
    StrawHat.Mailer.Repo
  ]
```

This way `ecto.create`, `ecto.migrate` and `ecto.drop` knows about the repo.
