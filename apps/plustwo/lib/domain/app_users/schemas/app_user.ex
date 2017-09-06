defmodule Plustwo.Domain.AppUsers.Schemas.AppUser do
  @moduledoc false

  use Plustwo.Domain, :schema

  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount

  @primary_key {:uuid, :binary_id, [autogenerate: false]}
  schema "app_user" do
    field :version, :integer, default: 0
    belongs_to :account,
               AppAccount,
               foreign_key: :app_account_uuid,
               references: :uuid,
               type: :binary_id
    field :given_name, :string
    field :lgiven_name, :string
    field :middle_name, :string
    field :family_name, :string
    field :lfamily_name, :string
    field :birthdate_day, :integer
    field :birthdate_month, :integer
    field :birthdate_year, :integer
  end
end
