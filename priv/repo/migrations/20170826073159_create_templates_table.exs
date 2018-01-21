defmodule StrawHat.Mailer.Repo.Migrations.CreateTemplatesTable do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add(:name, :string, null: false)
      add(:title, :string, null: false)
      add(:subject, :string, null: false)
      add(:owner_id, :string, null: false)
      add(:privacy, :string, default: "PRIVATE")
      add(:pre_header, :text)
      add(:html, :text)
      add(:text, :text)
    end

    create(index(:templates, [:owner_id, :name], unique: true))
  end
end
