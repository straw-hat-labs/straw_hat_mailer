defmodule StrawHat.Mailer.Repo.Migrations.CreatePartialsTable do
  use Ecto.Migration

  def change do
    create table(:partials) do
      add(:html_header, :text, null: false)
      add(:html_footer, :text, null: false)
      add(:text_header, :text, null: false)
      add(:text_footer, :text, null: false)
      add(:privacy, :string, default: "private")
      add(:owner_id, :string, null: false)
    end
  end
end
