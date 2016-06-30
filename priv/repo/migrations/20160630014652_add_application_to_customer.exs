defmodule Echo.Repo.Migrations.AddApplicationToCustomer do
  use Ecto.Migration

  def change do
    alter table(:customers) do
      add :application_id, references(:applications)
    end
    create index(:customers, [:application_id])
  end
end
