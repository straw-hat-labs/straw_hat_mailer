defmodule StrawHat.Mailer.Migrations.CreateTemplatesTable do
  @moduledoc """
  Creates templates table.

  Created at: ~N[2017-07-25 04:46:12]
  """

  use Ecto.Migration

  def change do
    create table(:templates, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:title, :string, null: false)
      add(:name, :string, null: false)
      add(:html, :text)
      add(:text, :text)
      add(:privacy, :string, default: "PRIVATE")
      add(:owner_id, :string, null: false)
      add(:subject, :string, null: false)
      add(:pre_header, :text)
      timestamps(type: :utc_datetime)
    end

    create(index(:templates, [:owner_id, :name], unique: true))
    create(index(:templates, [:name]))
  end
end
