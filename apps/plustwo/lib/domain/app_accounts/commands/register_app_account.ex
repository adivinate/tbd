defmodule Plustwo.Domain.AppAccounts.Commands.RegisterAppAccount do
  @moduledoc false

  defstruct uuid: "",
            is_org: false,
            handle_name: "",
            org_owner_app_account_uuid: "",
            email: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppAccounts.Commands.RegisterAppAccount
  alias Plustwo.Domain.AppAccounts.Validators.{UniqueAppAccountHandleName,
                                               UniqueAppAccountPrimaryEmail,
                                               AppAccountUuidMustExist}

  validates :uuid, presence: true, uuid: true
  validates :is_org, boolean: true
  validates :handle_name,
            presence: true,
            string: true,
            handle_name: true,
            length: [min: 2],
            by: [
              function: &UniqueAppAccountHandleName.validate/2,
              allow_blank: false,
              allow_nil: false,
            ]
  validates :org_owner_app_account_uuid,
            presence: [if: [is_org: true]],
            uuid: true,
            by: [
              function: &AppAccountUuidMustExist.validate/2,
              allow_blank: true,
              allow_nil: nil,
            ]
  validates :email,
            presence: true,
            string: true,
            email: true,
            by: [
              function: &UniqueAppAccountPrimaryEmail.validate/2,
              allow_blank: false,
              allow_nil: false,
            ]

  @doc "Assigns UUID to app account."
  def assign_uuid(%RegisterAppAccount{} = app_account, uuid) do
    %RegisterAppAccount{app_account | uuid: uuid}
  end


  @doc "Downcases app account handle name."
  def downcase_handle_name(%RegisterAppAccount{handle_name: handle_name} =
                             app_account) do
    %RegisterAppAccount{app_account | handle_name: String.downcase(handle_name)}
  end


  @doc "Downcases app account email."
  def downcase_email(%RegisterAppAccount{email: email} = app_account) do
    %RegisterAppAccount{app_account | email: String.downcase(email)}
  end
end
