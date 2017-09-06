defmodule Plustwo.Application.Schemas.Types.AppAccount do
  @moduledoc false

  use Plustwo.Application, :schema

  @desc "An app account on Plustwo."
  object :app_account do
    field :uuid, :string
    field :is_activated, :boolean
    field :is_suspended, :boolean
    field :is_employee, :boolean
    field :is_contributor, :boolean
    field :is_org, :boolean
    field :emails, list_of(:app_account_email)
    field :handle_name, :string
  end
  @desc "An email associated with an app account."
  object :app_account_email do
    field :address, :string
    field :type, :integer
    field :is_verified, :boolean
  end
end
