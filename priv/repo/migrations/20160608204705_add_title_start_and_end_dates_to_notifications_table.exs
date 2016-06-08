defmodule Echo.Repo.Migrations.AddTitleStartAndEndDatesToNotificationsTable do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :title, :string
      add :start_at, :datetime
      add :end_at, :datetime
    end
  end
end
