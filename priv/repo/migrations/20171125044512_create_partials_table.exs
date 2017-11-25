defmodule StrawHat.Mailer.Repo.Migrations.CreatePartialsTable do
  use Ecto.Migration

  def change do
    create table(:partials) do
      add(:header, :text, null: false)
      add(:footer, :text, null: false)
      add(:owner_id, :string, null: false)
    end
  end
end
