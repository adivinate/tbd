defmodule Plustwo.Domain.AppAccounts.Schemas.AppAccountEmail do
  @moduledoc false

  use Plustwo.Domain, :schema

  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount

  schema "app_account_email" do
    field :version, :integer, default: 0
    belongs_to :account,
               AppAccount,
               foreign_key: :app_account_uuid,
               references: :uuid,
               type: :binary_id
    field :address, :string
    field :type, :integer
    field :is_verified, :boolean
  end
end
