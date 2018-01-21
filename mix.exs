defmodule StrawHat.Mailer.Mixfile do
  use Mix.Project

  @name :straw_hat_mailer
  @version "0.4.0"
  @elixir_version "~> 1.5"

  @description """
  Email Management
  """
  @source_url "https://github.com/straw-hat-team/straw_hat_mailer"

  def project do
    production? = Mix.env() == :prod

    [
      name: "StrawHat.Mailer",
      description: @description,
      app: @name,
      version: @version,
      elixir: @elixir_version,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      aliases: aliases(),
      build_embedded: production?,
      start_permanent: production?,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test
      ],

      # Extras
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      mod: {StrawHat.Mailer.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:straw_hat, "~> 0.2"},
      {:postgrex, "~> 0.13.2"},
      {:ecto, "~> 2.2"},
      {:scrivener_ecto, "~> 1.2"},
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
      {:benchee, ">= 0.0.0", only: [:dev], runtime: false},
      {:benchee_html, ">= 0.0.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
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
        Interactors: [
          StrawHat.Mailer.Template,
          StrawHat.Mailer.Partial,
          StrawHat.Mailer.Email,
          StrawHat.Mailer
        ],
        Schemas: [
          StrawHat.Mailer.Schema.Privacy,
          StrawHat.Mailer.Schema.Partial,
          StrawHat.Mailer.Schema.Template,
          StrawHat.Mailer.Schema.TemplatePartial
        ]
      ]
    ]
  end
end
