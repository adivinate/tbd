defmodule Plustwo.Domain.AppOrgs.Schemas.AppOrgMember do
  @moduledoc false

  use Plustwo.Domain, :schema

  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount
  alias Plustwo.Domain.AppOrgs.Schemas.AppOrg

  @primary_key {:uuid, :binary_id, [autogenerate: false]}
  schema "app_org_member" do
    field :version, :integer, default: 0
    belongs_to :app_account,
               AppAccount,
               foreign_key: :app_account_uuid,
               references: :uuid,
               type: :binary_id
    belongs_to :app_org,
               AppOrg,
               foreign_key: :app_org_uuid, references: :uuid, type: :binary_id
    field :is_owner, :boolean
    field :is_representative, :boolean
    field :is_admin, :boolean
    field :is_membership_visible_to_public, :boolean
    field :joined_at, Calecto.DateTimeUTC
  end
end
