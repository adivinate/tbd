defmodule Plustwo.Domain.AppAccounts.Aggregates.AppAccount do
  @moduledoc false

  defstruct uuid: nil,
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
                emails: add_billing_email(app_account.emails, added)}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountBillingEmailRemoved{} = removed) do
    %AppAccount{app_account |
                emails: remove_billing_email(app_account.emails, removed)}
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

  def apply(%AppAccount{} = app_account,
            %AppAccountPrimaryEmailUpdated{} = updated) do
    %AppAccount{app_account |
                emails: replace_primary_email(app_account.emails, updated)}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountPrimaryEmailVerified{} = verified) do
    %AppAccount{app_account |
                emails: set_primary_email_verified(app_account.emails,
                                                   verified)}
  end

  def apply(%AppAccount{} = app_account,
            %AppAccountRegistered{} = registered) do
    %AppAccount{app_account |
                uuid: registered.uuid,
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


  defp add_billing_email(emails, %AppAccountBillingEmailAdded{} = added) do
    MapSet.put emails, %{address: added.billing_email, type: 1}
  end


  defp remove_billing_email(emails,
                            %AppAccountBillingEmailRemoved{} = removed) do
    current_billing_email =
      Enum.find(emails,
                fn email ->
                  email.type == 1 and email.address == removed.billing_email
                end)
    MapSet.delete emails, current_billing_email
  end


  defp replace_primary_email(emails,
                             %AppAccountPrimaryEmailUpdated{} = updated) do
    MapSet.new emails, fn
                 %{type: 0} = current_primary_email ->
                   %{
                     current_primary_email |
                     address: updated.primary_email,
                     is_verified: updated.is_primary_email_verified,
                   }

                 any ->
                   any
               end
  end


  defp set_primary_email_verified(emails,
                                  %AppAccountPrimaryEmailVerified{} =
                                    verified) do
    MapSet.new emails, fn
                 %{type: 0} = current_primary_email ->
                   %{
                     current_primary_email |
                     is_verified: verified.is_primary_email_verified,
                   }

                 any ->
                   any
               end
  end
end
