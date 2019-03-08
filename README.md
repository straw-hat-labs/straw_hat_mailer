# StrawHat.Mailer

[![Hex.pm](https://img.shields.io/hexpm/v/straw_hat_mailer.svg)](https://hex.pm/packages/straw_hat_mailer)
[![CI Status](https://travis-ci.org/straw-hat-team/straw_hat_mailer.svg?branch=master)](https://travis-ci.org/straw-hat-team/straw_hat_mailer)
[![Code Coverage](https://codecov.io/gh/straw-hat-team/straw_hat_mailer/branch/master/graph/badge.svg)](https://codecov.io/gh/straw-hat-team/straw_hat_mailer)

Email Management with templating capability. The templates use Mustache template
under the hood so you can do everything that the template system allow you to do.

### Configuration

We need to setup `Swoosh` adapter to be able to send the emails and the database
for save the templates.

```elixir
# In your config files
config :straw_hat_mailer, StrawHat.Mailer,
  # Swoosh.Adapters.Local for development
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "SG.x.x"
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
  privacy: StrawHat.Mailer.Privacy.public(),
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
  privacy: StrawHat.Mailer.Privacy.public(),

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
  privacy: StrawHat.Mailer.Privacy.public(),

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
  "full_name" => "My name is Jeff"
}

MyApp.send_welcome_email(to, data)
```

## Use cases

All the APIs are contain in the business use cases are under `Use Cases`
documentation section. Check the available modules and the public API.

You should be able to comprehend the API by reading the type spec and the
function name. Please open an issue or even better make pull request about the
documation if you have any issues with it.

## Migrations

Since this library does not have any repository, it does not run any migration.
You will need to handle the migrations on your application that contains the
repository.

The `migrations` directory contains a series of migrations that should cover
the common use cases.

> **Note**
>
> Each migration module has a `Created at` timestamp, this information is useful
> to decide when and the order on which the migrations should be run.

### Using migrations

After creating an Ecto migration in your project you could call one of the
migrations from your `change` callback in your module.

```elixir
defmodule MyApp.Repo.Migrations.CreatePartialsTable do
  use Ecto.Migration

  def change do
    StrawHat.Mailer.Migrations.CreatePartialsTable.change()
  end
end
```
