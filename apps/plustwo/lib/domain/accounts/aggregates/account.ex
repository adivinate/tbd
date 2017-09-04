defmodule Plustwo.Domain.Accounts.Aggregates.Account do
  @moduledoc "A central account for user and organization.\n\n## Types of Email\n\n  * 0 - Primary email. All user account should have one.\n  * 1 - Billing email. All organization account should have at least one.\n\n## Email Structure\n\nEach email in the emails MapSet has the following strucutre\n\n  1. address - Email address\n  2. type - Email type\n  3. is_verified - Email address is verified. Organization doesn't need to verify\n"

  defstruct uuid: nil,
            is_activated: nil,
            is_suspended: nil,
            is_employee: nil,
            is_contributor: nil,
            is_org: nil,
            handle_name: nil,
            emails: MapSet.new(),
            joined_at: nil
  alias Plustwo.Domain.Accounts.Aggregates.Account
  alias Plustwo.Domain.Accounts.Events.{AccountActivated,
                                        AccountBillingEmailAdded,
                                        AccountBillingEmailRemoved,
                                        AccountDeactivated,
                                        AccountHandleNameChanged,
                                        AccountMarkedAsContributor,
                                        AccountMarkedAsEmployee,
                                        AccountMarkedAsNonContributor,
                                        AccountMarkedAsNonEmployee,
                                        AccountPrimaryEmailUpdated,
                                        AccountPrimaryEmailVerified,
                                        AccountRegistered,
                                        AccountSuspended,
                                        AccountSuspensionLifted}

  def apply(%Account{} = account,
            %AccountActivated{is_activated: is_activated}) do
    %Account{account | is_activated: is_activated}
  end

  def apply(%Account{} = account, %AccountBillingEmailAdded{} = added) do
    %Account{account | emails: add_billing_email(account.emails, added)}
  end

  def apply(%Account{} = account, %AccountBillingEmailRemoved{} = removed) do
    %Account{account | emails: remove_billing_email(account.emails, removed)}
  end

  def apply(%Account{} = account,
            %AccountDeactivated{is_activated: is_activated}) do
    %Account{account | is_activated: is_activated}
  end

  def apply(%Account{} = account,
            %AccountHandleNameChanged{handle_name: handle_name}) do
    %Account{account | handle_name: handle_name}
  end

  def apply(%Account{} = account,
            %AccountMarkedAsContributor{is_contributor: is_contributor}) do
    %Account{account | is_contributor: is_contributor}
  end

  def apply(%Account{} = account,
            %AccountMarkedAsEmployee{is_employee: is_employee}) do
    %Account{account | is_employee: is_employee}
  end

  def apply(%Account{} = account,
            %AccountMarkedAsNonContributor{is_contributor: is_contributor}) do
    %Account{account | is_contributor: is_contributor}
  end

  def apply(%Account{} = account,
            %AccountMarkedAsNonEmployee{is_employee: is_employee}) do
    %Account{account | is_employee: is_employee}
  end

  def apply(%Account{} = account, %AccountPrimaryEmailUpdated{} = updated) do
    %Account{account | emails: replace_primary_email(account.emails, updated)}
  end

  def apply(%Account{} = account, %AccountPrimaryEmailVerified{} = verified) do
    %Account{account |
             emails: set_primary_email_verified(account.emails, verified)}
  end

  def apply(%Account{} = account, %AccountRegistered{} = registered) do
    %Account{account |
             uuid: registered.uuid,
             is_activated: registered.is_activated,
             is_suspended: registered.is_suspended,
             is_employee: registered.is_employee,
             is_contributor: registered.is_contributor,
             is_org: registered.is_org,
             handle_name: registered.handle_name,
             emails: MapSet.put(account.emails,
                                %{
                                  address: registered.email,
                                  type: registered.email_type,
                                  is_verified: registered.is_email_verified,
                                })}
  end

  def apply(%Account{} = account,
            %AccountSuspended{is_suspended: is_suspended}) do
    %Account{account | is_suspended: is_suspended}
  end

  def apply(%Account{} = account,
            %AccountSuspensionLifted{is_suspended: is_suspended}) do
    %Account{account | is_suspended: is_suspended}
  end


  ##########
  # Private Helpers
  ##########
  defp add_billing_email(emails, %AccountBillingEmailAdded{} = added) do
    MapSet.put emails, %{address: added.billing_email, type: 1}
  end


  defp remove_billing_email(emails, %AccountBillingEmailRemoved{} = removed) do
    current_billing_email =
      Enum.find(emails,
                fn email ->
                  email.type == 1 and email.address == removed.billing_email
                end)
    MapSet.delete emails, current_billing_email
  end


  defp replace_primary_email(emails, %AccountPrimaryEmailUpdated{} = updated) do
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
                                  %AccountPrimaryEmailVerified{} = verified) do
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
