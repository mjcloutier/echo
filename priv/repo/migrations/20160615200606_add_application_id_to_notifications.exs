defmodule Echo.Repo.Migrations.AddApplicationIdToNotifications do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :application_id, references(:applications)
    end
    create index(:notifications, [:application_id])
  end
end
