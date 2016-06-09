defmodule Echo.Repo.Migrations.AddSummaryToNotifications do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :summary, :string
    end
  end
end
