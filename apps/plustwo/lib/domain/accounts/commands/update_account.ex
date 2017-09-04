defmodule Plustwo.Domain.Accounts.Commands.UpdateAccount do
  @moduledoc false

  defstruct account_uuid: "",
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

  alias Plustwo.Domain.Accounts.Commands.UpdateAccount
  alias Plustwo.Domain.Accounts.Validators.{AccountUuidMustExist,
                                            UniqueAccountHandleName,
                                            UniqueAccountPrimaryEmail}

  validates :account_uuid,
            presence: true, uuid: true, by: &AccountUuidMustExist.validate/2
  validates :is_activated, boolean: true
  validates :is_suspended, boolean: true
  validates :is_employee, boolean: true
  validates :is_contributor, boolean: true
  validates :handle_name,
            string: true,
            handle_name: true,
            length: [min: 2, allow_nil: true, allow_blank: true],
            by: [
              function: &UniqueAccountHandleName.validate/2,
              allow_nil: true,
              allow_blank: false,
            ]
  validates :primary_email,
            string: true,
            email: true,
            by: [
              function: &UniqueAccountPrimaryEmail.validate/2,
              allow_nil: true,
              allow_blank: false,
            ]
  validates :primary_email_verification_code, string: true
  validates :new_billing_email, string: true, email: true
  validates :remove_billing_email, string: true, email: true

  @doc "Assign account UUID."
  def assign_account_uuid(%UpdateAccount{} = account, account_uuid) do
    %UpdateAccount{account | account_uuid: account_uuid}
  end


  @doc "Downcase account handle name."
  def downcase_handle_name(%UpdateAccount{handle_name: nil} = account) do
    account
  end

  def downcase_handle_name(%UpdateAccount{handle_name: handle_name} =
                             account) do
    %UpdateAccount{account | handle_name: String.downcase(handle_name)}
  end


  @doc "Downcase account primary email"
  def downcase_primary_email(%UpdateAccount{primary_email: nil} = account) do
    account
  end

  def downcase_primary_email(%UpdateAccount{primary_email: primary_email} =
                               account) do
    %UpdateAccount{account | primary_email: String.downcase(primary_email)}
  end
end
