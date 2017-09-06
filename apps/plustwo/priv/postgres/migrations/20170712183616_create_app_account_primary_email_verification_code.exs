defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateAppAccountPrimaryEmailVerificationCode do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:app_account_primary_email_verification_code) do
      add :app_account_uuid,
          references(:app_account, column: :uuid, type: :uuid)
      add :verification_code_hash, :string
    end
    create unique_index(:app_account_primary_email_verification_code,
                        [:app_account_uuid],
                        name: :app_account_primary_email_verification_code_app_account_uuid)
  end
end
