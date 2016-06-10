defmodule Echo.Repo.Migrations.AddSessionInfo do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :session_count, :integer
    end
  end
end
