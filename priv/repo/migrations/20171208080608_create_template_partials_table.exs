defmodule StrawHat.Mailer.Repo.Migrations.CreateTemplatePartialsTable do
  use Ecto.Migration

  def change do
    create table(:template_partials, primary_key: false) do
      add(:template_id, references(:templates), primary_key: true)
      add(:partial_id, references(:partials), primary_key: true)
    end
  end
end
