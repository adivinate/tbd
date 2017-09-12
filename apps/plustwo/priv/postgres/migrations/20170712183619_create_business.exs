defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateBusiness do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:business, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :version, :integer, default: 0
      add :app_account_uuid,
          references(:app_account, column: :uuid, type: :uuid)
      add :legal_name, :string
      add :legal_lname, :string
      add :description, :string
      add :address_street, :string
      add :address_locality, :string
      add :address_region, :string
      add :address_postal_code, :string
      add :website_url, :string
      add :phone_number, :string
      add :email_address, :string
    end
    create index(:business, [:legal_lname])
    create unique_index(:business,
                        [:app_account_uuid],
                        name: :business_app_account_uuid)
  end
end
