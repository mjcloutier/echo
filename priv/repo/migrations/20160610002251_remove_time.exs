defmodule Echo.Repo.Migrations.RemoveTime do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      remove :start_at
      remove :end_at
      add :start_at, :date
      add :end_at, :date
    end
  end
end
