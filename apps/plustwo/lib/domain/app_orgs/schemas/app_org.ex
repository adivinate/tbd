defmodule Plustwo.Domain.AppOrgs.Schemas.AppOrg do
  @moduledoc false

  use Plustwo.Domain, :schema

  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount
  alias Plustwo.Domain.AppOrgs.Schemas.AppOrgMember

  @primary_key {:uuid, :binary_id, [autogenerate: false]}
  schema "app_org" do
    field :version, :integer, default: 0
    belongs_to :app_account,
               AppAccount,
               foreign_key: :app_account_uuid,
               references: :uuid,
               type: :binary_id
    field :type, :integer
    field :name, :string
    field :lname, :string
    field :start_date, Calecto.DateTimeUTC
    field :mission, :string
    field :description, :string
    field :website_url, :string
    field :phone_number, :string
    field :email_address, :string
    has_many :members, AppOrgMember
  end
end
