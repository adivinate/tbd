defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateAppAccountEmail do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:app_account_email) do
      add :version, :integer, default: 0
      add :app_account_uuid,
          references(:app_account, column: :uuid, type: :uuid)
      add :address, :string
      add :type, :integer
      add :is_verified, :boolean
    end
  end
end
