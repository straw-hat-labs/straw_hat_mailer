defmodule StrawHat.Mailer.Repo.Migrations.CreatePartialsTable do
  use Ecto.Migration

  def change do
    create table(:partials) do
      add(:key, :string, null: false)
      add(:html, :text)
      add(:text, :text)
      add(:privacy, :string, default: "private")
      add(:owner_id, :string, null: false)
    end
  end
end
