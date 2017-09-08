defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateAppOrg do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:app_org, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :version, :integer, default: 0
      add :app_account_uuid,
          references(:app_account, column: :uuid, type: :uuid)
      add :type, :integer
      add :name, :string
      add :lname, :string
      add :start_date, :utc_datetime
      add :mission, :string
      add :description, :string
      add :website_url, :string
      add :phone_number, :string
      add :email_address, :string
    end
    create unique_index(:app_org,
                        [:app_account_uuid],
                        name: :app_org_app_account_uuid)
  end
end
