defmodule Plustwo.Domain.AppAccounts.Aggregates.AppAccount do
  @moduledoc false

  defstruct app_account_uuid: nil,
            is_activated: nil,
            is_suspended: nil,
            is_employee: nil,
            is_contributor: nil,
            is_org: nil,
            handle_name: nil,
            emails: MapSet.new(),
            joined_at: nil
  alias Plustwo.Domain.AppAccounts.Aggregates.AppAccount
  alias Plustwo.Domain.AppAccounts.Events.{AppAccountActivated,
                                           AppAccountBillingEmailAdded,
                                           AppAccountBillingEmailRemoved,
                                           AppAccountDeactivated,
                                           AppAccountHandleNameChanged,
                                           AppAccountMarkedAsContributor,
                                           AppAccountMarkedAsEmployee,
                                           AppAccountMarkedAsNonContributor,
                                           AppAccountMarkedAsNonEmployee,
                                           AppAccountPrimaryEmailUpdated,
                                           AppAccountPrimaryEmailVerified,
                                           AppAccountRegistered,
                                           AppAccountSuspended,
                                           AppAccountSuspensionLifted}

  def apply(%AppAccount{} = app_account,
            %AppAccountActivated{is_activated: is_activated}) do
    %AppAccount{app_account | is_activated: is_activated}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountBillingEmailAdded{} = added) do
    %AppAccount{app_account |
                emails: MapSet.put(app_account.emails,
                                   %{address: added.email_address, type: 1})}
  end

  def apply(%AppAccount{emails: emails} = app_account,
            %AppAccountBillingEmailRemoved{} = removed) do
    current_billing_email =
      Enum.find(emails,
                fn email ->
                  email.type == 1 and email.address == removed.email_address
                end)
    %AppAccount{app_account |
                emails: MapSet.delete(app_account.emails,
                                      current_billing_email)}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountDeactivated{is_activated: is_activated}) do
    %AppAccount{app_account | is_activated: is_activated}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountHandleNameChanged{handle_name: handle_name}) do
    %AppAccount{app_account | handle_name: handle_name}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountMarkedAsContributor{is_contributor: is_contributor}) do
    %AppAccount{app_account | is_contributor: is_contributor}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountMarkedAsEmployee{is_employee: is_employee}) do
    %AppAccount{app_account | is_employee: is_employee}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountMarkedAsNonContributor{is_contributor: is_contributor}) do
    %AppAccount{app_account | is_contributor: is_contributor}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountMarkedAsNonEmployee{is_employee: is_employee}) do
    %AppAccount{app_account | is_employee: is_employee}
  end

  def apply(%AppAccount{emails: emails} = app_account,
            %AppAccountPrimaryEmailUpdated{} = updated) do
    %AppAccount{app_account | emails: MapSet.new(emails, fn
                                                   %{type: 0} =
                                                        current_primary_email ->
                                                     %{
                                                       current_primary_email |
                                                       address: updated.email_address,
                                                       is_verified: updated.is_verified,
                                                     }

                                                   any ->
                                                     any
                                                 end)}
  end

  def apply(%AppAccount{emails: emails} = app_account,
            %AppAccountPrimaryEmailVerified{} = verified) do
    %AppAccount{app_account | emails: MapSet.new(emails, fn
                                                   %{type: 0} =
                                                        current_primary_email ->
                                                     %{
                                                       current_primary_email |
                                                       is_verified: verified.is_verified,
                                                     }

                                                   any ->
                                                     any
                                                 end)}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountRegistered{} = registered) do
    %AppAccount{app_account |
                app_account_uuid: registered.app_account_uuid,
                is_activated: registered.is_activated,
                is_suspended: registered.is_suspended,
                is_employee: registered.is_employee,
                is_contributor: registered.is_contributor,
                is_org: registered.is_org,
                handle_name: registered.handle_name,
                emails: MapSet.put(app_account.emails,
                                   %{
                                     address: registered.email,
                                     type: registered.email_type,
                                     is_verified: registered.is_email_verified,
                                   })}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountSuspended{is_suspended: is_suspended}) do
    %AppAccount{app_account | is_suspended: is_suspended}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountSuspensionLifted{is_suspended: is_suspended}) do
    %AppAccount{app_account | is_suspended: is_suspended}
  end
end
