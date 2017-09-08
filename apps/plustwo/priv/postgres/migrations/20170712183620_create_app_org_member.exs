defmodule Plustwo.Infrastructure.Repo.Postgres.Migrations.CreateAppOrgMember do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:app_org_member, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :version, :integer, default: 0
      add :app_account_uuid,
          references(:app_account, column: :uuid, type: :uuid)
      add :app_org_uuid, references(:app_org, column: :uuid, type: :uuid)
      add :is_owner, :boolean
      add :is_representative, :boolean
      add :is_admin, :boolean
      add :is_membership_visible_to_public, :boolean
      add :joined_at, :utc_datetime
    end
    create unique_index(:app_org_member,
                        [:app_account_uuid, :app_org_uuid],
                        name: :app_org_member_membership)
  end
end
