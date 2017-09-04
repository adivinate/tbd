defmodule Plustwo.Domain.Accounts.Schemas.AccountEmail do
  @moduledoc false

  use Plustwo.Domain, :schema
  alias Plustwo.Domain.Accounts.Schemas.Account

  schema "account_email" do
    field :version, :integer, default: 0
    belongs_to :account, Account,
      foreign_key: :account_uuid,
      references: :uuid,
      type: :binary_id
    field :address, :string
    field :type, :integer
    field :is_verified, :boolean
  end
end
