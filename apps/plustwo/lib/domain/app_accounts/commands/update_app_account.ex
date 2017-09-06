defmodule Plustwo.Domain.AppAccounts.Commands.UpdateAppAccount do
  @moduledoc false

  defstruct uuid: "",
            is_activated: nil,
            is_suspended: nil,
            is_employee: nil,
            is_contributor: nil,
            handle_name: nil,
            primary_email: nil,
            primary_email_verification_code: nil,
            new_billing_email: nil,
            remove_billing_email: nil
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppAccounts.Commands.UpdateAppAccount
  alias Plustwo.Domain.AppAccounts.Validators.{AppAccountUuidMustExist,
                                               UniqueAppAccountHandleName,
                                               UniqueAppAccountPrimaryEmail}

  validates :uuid,
            presence: true,
            uuid: true,
            by: [
              function: &AppAccountUuidMustExist.validate/2,
              allow_nil: false,
              allow_blank: false,
            ]
  validates :is_activated, boolean: true
  validates :is_suspended, boolean: true
  validates :is_employee, boolean: true
  validates :is_contributor, boolean: true
  validates :handle_name,
            string: true,
            handle_name: true,
            length: [min: 2, allow_nil: true, allow_blank: true],
            by: [
              function: &UniqueAppAccountHandleName.validate/2,
              allow_nil: true,
              allow_blank: false,
            ]
  validates :primary_email,
            string: true,
            email: true,
            by: [
              function: &UniqueAppAccountPrimaryEmail.validate/2,
              allow_nil: true,
              allow_blank: false,
            ]
  validates :primary_email_verification_code, string: true
  validates :new_billing_email, string: true, email: true
  validates :remove_billing_email, string: true, email: true

  @doc "Assigns app account UUID."
  def assign_uuid(%UpdateAppAccount{} = app_account, uuid) do
    %UpdateAppAccount{app_account | uuid: uuid}
  end


  @doc "Downcases app account handle name."
  def downcase_handle_name(%UpdateAppAccount{handle_name: nil} = app_account) do
    app_account
  end

  def downcase_handle_name(%UpdateAppAccount{handle_name: handle_name} =
                             app_account) do
    %UpdateAppAccount{app_account | handle_name: String.downcase(handle_name)}
  end


  @doc "Downcases app account primary email"
  def downcase_primary_email(%UpdateAppAccount{primary_email: nil} =
                               app_account) do
    app_account
  end

  def downcase_primary_email(%UpdateAppAccount{primary_email: primary_email} =
                               app_account) do
    %UpdateAppAccount{app_account |
                      primary_email: String.downcase(primary_email)}
  end
end
