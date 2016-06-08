defmodule Echo.Repo.Migrations.CreateSentNotification do
  use Ecto.Migration

  def change do
    create table(:sent_notifications) do
      add :notification_id, :integer
      add :customer_id, :integer
      add :acknowledged, :boolean, default: false

      timestamps
    end

  end
end
