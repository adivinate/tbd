defmodule Plustwo.Domain.AppOrgs.Commands.UpdateAppOrg do
  @moduledoc false

  defstruct app_org_uuid: "",
            name: "",
            start_date: "",
            mission: "",
            description: "",
            website_url: "",
            phone_number: "",
            email_address: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppOrgs.Commands.UpdateAppOrg
  alias Plustwo.Domain.AppOrgs.Validators.AppOrgUuidMustExist

  validates :app_org_uuid,
            presence: true,
            uuid: true,
            by: [
              function: &AppOrgUuidMustExist.validate/2,
              allow_blank: false,
              allow_nil: false,
            ]
  validates :name, string: true
  validates :description, string: true
  validates :mission, string: true
  validates :start_date, date: true
  validates :website_url, string: true, url: true
  validates :phone_number, string: true, phone_number: true
  validates :email_address, string: true, email: true

  @doc "Assigns app organization UUID."
  def assign_app_org_uuid(%UpdateAppOrg{} = app_org, app_org_uuid) do
    %UpdateAppOrg{app_org | app_org_uuid: app_org_uuid}
  end


  @doc "Downcases app organization email_address."
  def downcase_email_address(%UpdateAppOrg{email_address: nil} = app_org) do
    app_org
  end

  def downcase_email_address(%UpdateAppOrg{email_address: email_address} =
                               app_org) do
    %UpdateAppOrg{app_org | email_address: email_address}
  end
end
