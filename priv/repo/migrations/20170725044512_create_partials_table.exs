defmodule StrawHat.Mailer.Repo.Migrations.CreatePartialsTable do
  use Ecto.Migration

  def change do
    create table(:partials) do
      add(:name, :string, null: false)
      add(:html, :text)
      add(:text, :text)
      add(:privacy, :string, default: "PRIVATE")
      add(:owner_id, :string, null: false)
    end

    create(index(:partials, [:owner_id, :name], unique: true))
  end
end
