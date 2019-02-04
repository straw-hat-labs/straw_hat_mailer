defmodule StrawHat.Mailer.TestSupport.Repo.Migrations.RunAllMigrations do
  use Ecto.Migration

  def change do
    Enum.map(
      [
        StrawHat.Mailer.Migrations.CreatePartialsTable,
        StrawHat.Mailer.Migrations.CreateTemplatesTable,
        StrawHat.Mailer.Migrations.CreateTemplatePartialsTable
      ],
      &apply(&1, :change, [])
    )
  end
end
