defmodule Plustwo.Domain.Accounts.Schemas.AccountPrimaryEmailVerificationCode do
  @moduledoc false

  use Plustwo.Domain, :schema

  schema "account_primary_email_verification_code" do
    field :account_uuid, :binary_id
    field :verification_code_hash, :string
  end
end
