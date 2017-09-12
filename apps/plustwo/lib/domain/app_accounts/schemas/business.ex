defmodule Plustwo.Domain.AppAccounts.Schemas.Business do
  @moduledoc false

  use Plustwo.Domain, :schema

  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount

  @primary_key {:uuid, :binary_id, [autogenerate: false]}
  schema "business" do
    field :version, :integer, default: 0
    belongs_to :app_account,
               AppAccount,
               foreign_key: :app_account_uuid,
               references: :uuid,
               type: :binary_id
    field :legal_name, :string
    field :legal_lname, :string
    field :description, :string
    field :address_street, :string
    field :address_locality, :string
    field :address_region, :string
    field :address_postal_code, :string
    field :website_url, :string
    field :phone_number, :string
    field :email_address, :string
  end
end
