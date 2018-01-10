defmodule StrawHat.Mailer.Repo.Migrations.CreateTemplatePartialsTable do
  use Ecto.Migration

  def change do
    create table(:template_partials) do
      add(:template_id, references(:templates), null: false, on_delete: :delete_all)
      add(:partial_id, references(:partials), null: false, on_delete: :delete_all)
    end

    create index(:template_partials, [:template_id, :partial_id], unique: true)
  end
end
