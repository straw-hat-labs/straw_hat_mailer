defmodule StrawHat.Mailer.Migrations.CreatePartialsTable do
  @moduledoc """
  Creates partials table.

  Created at: ~N[2017-07-25 04:45:12]
  """

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
