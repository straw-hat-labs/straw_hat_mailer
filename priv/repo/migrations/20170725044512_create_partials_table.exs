defmodule StrawHat.Mailer.Repo.Migrations.CreatePartialsTable do
  use Ecto.Migration

  def change do
    create table(:partials, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:title, :string, null: false)
      add(:name, :string, null: false)
      add(:html, :text)
      add(:text, :text)
      add(:privacy, :string, default: "PRIVATE")
      add(:owner_id, :string, null: false)
      timestamps(type: :utc_datetime)
    end

    create(index(:partials, [:owner_id, :name], unique: true))
    create(index(:partials, [:name]))
  end
end
