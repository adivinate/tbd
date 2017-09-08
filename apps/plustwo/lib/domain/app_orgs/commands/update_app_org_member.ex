defmodule Plustwo.Domain.AppOrgs.Commands.UpdateAppOrgMember do
  @moduledoc false

  defstruct app_org_uuid: "",
            app_account_uuid: "",
            is_remove: "",
            is_new: "",
            is_owner: "",
            is_representative: "",
            is_admin: "",
            is_membership_visible_to_public: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppOrgs.Commands.UpdateAppOrgMember
  alias Plustwo.Domain.AppOrgs.Validators.{AppAccountUuidMustExist,
                                           AppOrgUuidMustExist}

  validates :app_org_uuid,
            presence: true,
            uuid: true,
            by: [
              function: &AppOrgUuidMustExist.validate/2,
              allow_blank: false,
              allow_nil: false,
            ]
  validates :app_account_uuid,
            presence: true,
            uuid: true,
            by: [
              function: &AppAccountUuidMustExist.validate/2,
              allow_blank: true,
              allow_nil: true,
            ]
  validates :is_remove, boolean: true
  validates :is_new, boolean: true
  validates :is_owner, boolean: true
  validates :is_representative, boolean: true
  validates :is_admin, boolean: true

  @doc "Assigns app org UUID."
  def assign_app_org_uuid(%UpdateAppOrgMember{} = app_org_member,
                          app_org_uuid) do
    %UpdateAppOrgMember{app_org_member | app_org_uuid: app_org_uuid}
  end


  @doc "Assigns app account UUID."
  def assign_app_account_uuid(%UpdateAppOrgMember{} = app_org_member,
                              app_account_uuid) do
    %UpdateAppOrgMember{app_org_member | app_account_uuid: app_account_uuid}
  end
end
