defmodule Echo.Repo.Migrations.AddApplicationIdToNotifications do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :application_id, references(:notifications)
    end
  end
end
