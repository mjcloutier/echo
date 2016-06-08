defmodule Echo.Repo.Migrations.CreateNotification do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :body, :text

      timestamps
    end

  end
end
