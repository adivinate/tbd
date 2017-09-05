defmodule Plustwo.Domain.Users.Schemas.User do
  @moduledoc false

  use Plustwo.Domain, :schema

  @primary_key {:uuid, :binary_id, [autogenerate: false]}
  schema "plustwo_user" do
    field :version, :integer, default: 0
    field :account_uuid, :binary_id
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
