defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.EmailVerification do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:email_verification) do
      add :app_account_uuid,
          references(:app_account, column: :uuid, type: :uuid)
      add :email_type, :integer
      add :code_hash, :string
    end
  end
end
