defmodule Plustwo.Domain.AppOrgs.Commands.CreateAppOrg do
  @moduledoc false

  defstruct app_org_uuid: "", app_account_uuid: "", type: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppOrgs.Commands.CreateAppOrg
  alias Plustwo.Domain.AppOrgs.Validators.AppAccountUuidMustExist

  validates :app_org_uuid, presence: true, uuid: true
  validates :app_account_uuid,
            presence: true,
            uuid: true,
            by: [
              function: &AppAccountUuidMustExist.validate/2,
              allow_nil: false,
              allow_blank: false,
            ]
  validates :type, presence: true, integer: true

  @doc "Assigns a unique app organization identity."
  def assign_app_org_uuid(%CreateAppOrg{} = app_org, app_org_uuid) do
    %CreateAppOrg{app_org | app_org_uuid: app_org_uuid}
  end


  @doc "Assigns app account UUID."
  def assign_app_account_uuid(%CreateAppOrg{} = app_org, app_account_uuid) do
    %CreateAppOrg{app_org | app_account_uuid: app_account_uuid}
  end
end
