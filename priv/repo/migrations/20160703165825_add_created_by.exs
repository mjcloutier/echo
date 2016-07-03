defmodule Echo.Repo.Migrations.AddCreatedBy do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :created_by_id, references(:users)
    end
  end
end
