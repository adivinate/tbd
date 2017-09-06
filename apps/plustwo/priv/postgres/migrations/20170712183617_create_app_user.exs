defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateAppUser do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:app_user, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :version, :integer, default: 0
      add :app_account_uuid,
          references(:app_account, column: :uuid, type: :uuid)
      add :given_name, :string
      add :lgiven_name, :string
      add :middle_name, :string
      add :family_name, :string
      add :lfamily_name, :string
      add :birthdate_day, :integer
      add :birthdate_month, :integer
      add :birthdate_year, :integer
    end
    create unique_index(:app_user,
                        [:app_account_uuid],
                        name: :app_user_app_account_uuid)
  end
end
