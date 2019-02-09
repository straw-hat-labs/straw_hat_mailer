defmodule StrawHat.Mailer.MixProject do
  use Mix.Project

  @name :straw_hat_mailer
  @version "1.1.0"
  @elixir_version "~> 1.7"
  @source_url "https://github.com/straw-hat-team/straw_hat_mailer"

  def project do
    production? = Mix.env() == :prod

    [
      name: "StrawHat.Mailer",
      description: "Email Management",
      app: @name,
      version: @version,
      deps: deps(),
      elixir: @elixir_version,
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: production?,
      start_permanent: production?,
      aliases: aliases(),
      test_coverage: test_coverage(),
      preferred_cli_env: cli_env(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:straw_hat, "~> 0.4"},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:scrivener_ecto, "~> 2.0"},
      {:exnumerator, "~> 1.3"},
      {:swoosh, "~> 0.12"},
      {:bbmustache, "~> 1.5"},
      {:mustache, "~> 0.3.1", optional: true},

      # Testing
      {:ex_machina, ">= 0.0.0", only: [:test]},
      {:faker, ">= 0.0.0", only: [:test]},

      # Tools
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:excoveralls, ">= 0.0.0", only: [:test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false}
    ]
  end

  defp test_coverage do
    [tool: ExCoveralls]
  end

  defp cli_env do
    [
      "ecto.reset": :test,
      "ecto.setup": :test,
      "coveralls.html": :test,
      "coveralls.json": :test
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test --trace"]
    ]
  end

  defp package do
    [
      name: @name,
      files: [
        "lib",
        "priv",
        "mix.exs",
        "README*",
        "LICENSE*"
      ],
      maintainers: [
        "Yordis Prieto",
        "Osley Zorrilla"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      homepage_url: @source_url,
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"],
      groups_for_modules: [
        "Use Cases": [
          StrawHat.Mailer.Templates,
          StrawHat.Mailer.Partials,
          StrawHat.Mailer.Emails,
          StrawHat.Mailer
        ],
        Entities: [
          StrawHat.Mailer.Privacy,
          StrawHat.Mailer.Partial,
          StrawHat.Mailer.Template,
          StrawHat.Mailer.TemplatePartial
        ],
        Migrations: [
          StrawHat.Mailer.Migrations.CreatePartialsTable,
          StrawHat.Mailer.Migrations.CreateTemplatesTable,
          StrawHat.Mailer.Migrations.CreateTemplatePartialsTable
        ]
      ]
    ]
  end
end
