defmodule Plustwo.Domain.AppAccounts.Schemas.AppAccountPrimaryEmailVerificationCode do
  @moduledoc false

  use Plustwo.Domain, :schema

  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount

  schema "app_account_primary_email_verification_code" do
    belongs_to :account,
               AppAccount,
               foreign_key: :app_account_uuid,
               references: :uuid,
               type: :binary_id
    field :verification_code_hash, :string
  end
end
