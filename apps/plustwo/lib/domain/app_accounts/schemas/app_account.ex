defmodule Plustwo.Domain.AppAccounts.Schemas.AppAccount do
  @moduledoc false

  use Plustwo.Domain, :schema

  alias Plustwo.Domain.AppAccounts.Schemas.AppAccountEmail

  @primary_key {:uuid, :binary_id, [autogenerate: false]}
  schema "app_account" do
    field :version, :integer, default: 0
    field :is_activated, :boolean
    field :is_suspended, :boolean
    field :is_employee, :boolean
    field :is_contributor, :boolean
    field :is_org, :boolean
    field :handle_name, :string
    has_many :emails, AppAccountEmail
    field :joined_at, Calecto.DateTimeUTC
  end
end
