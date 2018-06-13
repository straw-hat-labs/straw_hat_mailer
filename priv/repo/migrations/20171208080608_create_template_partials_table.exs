defmodule StrawHat.Mailer.Repo.Migrations.CreateTemplatePartialsTable do
  use Ecto.Migration

  def change do
    create table(:template_partials, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(
        :template_id,
        references(:templates, type: :binary_id, on_delete: :delete_all),
        null: false
      )

      add(
        :partial_id,
        references(:partials, type: :binary_id, on_delete: :delete_all),
        null: false
      )

      timestamps(type: :utc_datetime)
    end

    create(index(:template_partials, [:template_id, :partial_id], unique: true))
  end
end
