defmodule Echo.Repo.Migrations.AddKeyAndSecretToApplications do
  use Ecto.Migration

  def change do
    alter table(:applications) do
      add :key, :string
      add :secret, :string
    end

    create index(:applications, [:key, :secret])
  end
end
