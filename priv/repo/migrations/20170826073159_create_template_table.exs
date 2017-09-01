defmodule StrawHat.Mailer.Repo.Migrations.CreateTemplateTable do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add(:name, :string, null: false)
      add(:service, :string, null: false)
      add(:from, :map, null: false)
      add(:subject, :string, null: false)
      add(:text_body, :string, null: false)
      add(:html_body, :string)
    end

    create index(:templates, [:name], unique: true)
  end
end
