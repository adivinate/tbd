defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateAccountPrimaryEmailVerificationCode do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:account_primary_email_verification_code) do
      add :account_uuid,
          references(:plustwo_account, column: :uuid, type: :uuid)
      add :verification_code_hash, :string
    end
    create unique_index(:account_primary_email_verification_code,
                        [:account_uuid],
                        name: :account_primary_email_verification_code_account_uuid)
  end
end
