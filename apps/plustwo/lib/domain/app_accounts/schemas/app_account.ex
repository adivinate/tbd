defmodule Plustwo.Domain.AppAccounts.Schemas.AppAccount do
  @moduledoc false

  use Plustwo.Domain, :schema

  alias Plustwo.Domain.AppAccounts.Schemas.{AppAccountEmail,
                                            Business,
                                            User}

  @primary_key {:uuid, :binary_id, [autogenerate: false]}
  schema "app_account" do
    field :version, :integer, default: 0
    field :type, :integer
    field :is_activated, :boolean
    field :is_suspended, :boolean
    field :handle_name, :string
    field :joined_at, Calecto.DateTimeUTC
    has_many :emails, AppAccountEmail
    has_one :user, User
    has_one :business, Business
  end
end
