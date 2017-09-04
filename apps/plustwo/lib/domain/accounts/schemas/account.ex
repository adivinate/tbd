defmodule Plustwo.Domain.Accounts.Schemas.Account do
  @moduledoc false

  use Plustwo.Domain, :schema

  alias Plustwo.Domain.Accounts.Schemas.AccountEmail

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "plustwo_account" do
    field :version, :integer, default: 0
    field :is_activated, :boolean
    field :is_suspended, :boolean
    field :is_employee, :boolean
    field :is_contributor, :boolean
    field :is_org, :boolean
    field :handle_name, :string
    has_many :emails, AccountEmail
    field :joined_at, Calecto.DateTimeUTC
  end
end
