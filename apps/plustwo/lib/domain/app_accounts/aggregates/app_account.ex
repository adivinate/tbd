defmodule Plustwo.Domain.AppAccounts.Aggregates.AppAccount do
  @moduledoc false

  defstruct app_account_uuid: nil,
            type: nil,
            is_activated: nil,
            is_suspended: nil,
            handle_name: nil,
            emails: MapSet.new(),
            joined_at: nil
  alias Plustwo.Domain.AppAccounts.Aggregates.AppAccount
  alias Plustwo.Domain.AppAccounts.Events.{AppAccountActivated,
                                           AppAccountBillingEmailAdded,
                                           AppAccountBillingEmailRemoved,
                                           AppAccountDeactivated,
                                           AppAccountHandleNameChanged,
                                           AppAccountPrimaryEmailUpdated,
                                           AppAccountPrimaryEmailVerified,
                                           AppAccountRegistered,
                                           AppAccountSuspended,
                                           AppAccountSuspensionLifted}

  def apply(%AppAccount{} = app_account, %AppAccountActivated{}) do
    %AppAccount{app_account | is_activated: true}
  end


  def akpply(%AppAccount{emails: emails} = app_account,
             %AppAccountBillingEmailAdded{email_address: email_address}) do
    %AppAccount{app_account |
                emails: MapSet.put(emails, %{address: email_address, type: 1})}
  end


  def apply(%AppAccount{emails: emails} = app_account,
            %AppAccountBillingEmailRemoved{email_address: email_address}) do
    current_billing_email =
      Enum.find(emails,
                fn email ->
                  email.type == 1 and email.address == email_address
                end)
    %AppAccount{app_account |
                emails: MapSet.delete(emails, current_billing_email)}
  end

  def apply(%AppAccount{} = app_account, %AppAccountDeactivated{}) do
    %AppAccount{app_account | is_activated: false}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountHandleNameChanged{handle_name: handle_name}) do
    %AppAccount{app_account | handle_name: handle_name}
  end

  def apply(%AppAccount{emails: emails} = app_account,
            %AppAccountPrimaryEmailUpdated{email_address: email_address}) do
    %AppAccount{app_account | emails: MapSet.new(emails, fn
                                                   %{type: 0} =
                                                        current_primary_email ->
                                                     %{
                                                       current_primary_email |
                                                       address: email_address,
                                                       is_verified: false,
                                                     }

                                                   any ->
                                                     any
                                                 end)}
  end

  def apply(%AppAccount{emails: emails} = app_account,
            %AppAccountPrimaryEmailVerified{}) do
    %AppAccount{app_account | emails: MapSet.new(emails, fn
                                                   %{type: 0} =
                                                        current_primary_email ->
                                                     %{
                                                       current_primary_email |
                                                       is_verified: true,
                                                     }

                                                   any ->
                                                     any
                                                 end)}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountRegistered{app_account_uuid: app_account_uuid,
                                  type: type,
                                  is_activated: is_activated,
                                  is_suspended: is_suspended,
                                  handle_name: handle_name,
                                  email_address: email_address,
                                  email_type: email_type,
                                  joined_at: joined_at}) do
    %AppAccount{app_account |
                app_account_uuid: app_account_uuid,
                type: type,
                is_activated: is_activated,
                is_suspended: is_suspended,
                handle_name: handle_name,
                emails: MapSet.put(app_account.emails,
                                   %{
                                     address: email_address,
                                     type: email_type,
                                     is_verified: false,
                                   }),
                joined_at: joined_at}
  end

  def apply(%AppAccount{} = app_account, %AppAccountSuspended{}) do
    %AppAccount{app_account | is_suspended: true}
  end

  def apply(%AppAccount{} = app_account, %AppAccountSuspensionLifted{}) do
    %AppAccount{app_account | is_suspended: false}
  end
end
