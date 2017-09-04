defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateAccountEmail do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:account_email) do
      add :version, :integer, default: 0
      add :account_uuid,
          references(:plustwo_account, column: :uuid, type: :uuid)
      add :address, :string
      add :type, :integer
      add :is_verified, :boolean
    end
    create unique_index(:account_email,
                        [:address],
                        name: :account_email_address)
  end
end
