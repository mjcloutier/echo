defmodule Echo.Repo.Migrations.CreateCustomer do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :app_user_id, :string

      timestamps
    end

  end
end
