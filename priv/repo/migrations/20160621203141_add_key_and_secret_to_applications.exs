defmodule Echo.Repo.Migrations.AddKeyAndSecretToApplications do
  use Ecto.Migration

  def change do
    alter table(:applications) do
      add :app_key, :string
      add :app_secret, :string
    end

    create index(:applications, [:app_key, :app_secret])
  end
end
