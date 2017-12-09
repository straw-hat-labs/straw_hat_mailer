defmodule StrawHat.Mailer.Repo.Migrations.CreateTemplatePartialTable do
  use Ecto.Migration

  def change do
    create table(:template_partial, primary_key: false) do
      add(:template_id, references(:templates))
      add(:partial_id, references(:partials))
    end
  end
end
