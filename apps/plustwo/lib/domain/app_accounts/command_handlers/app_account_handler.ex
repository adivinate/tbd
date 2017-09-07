defmodule Plustwo.Domain.AppAccounts.CommandHandlers.AppAccountHandler do
  @moduledoc false

  @behaviour Commanded.Commands.Handler
  alias Plustwo.Infrastructure.Components.{Crypto, EmailVerification}
  alias Plustwo.Domain.AppAccounts.Aggregates.AppAccount
  alias Plustwo.Domain.AppAccounts.Commands.{RegisterAppAccount,
                                             UpdateAppAccount}
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

  @doc "Register an app account for user."
  def handle(%AppAccount{app_account_uuid: nil},
             %RegisterAppAccount{is_org: false} = register) do
    %AppAccountRegistered{app_account_uuid: register.app_account_uuid,
                          is_activated: true,
                          is_suspended: false,
                          is_employee: false,
                          is_contributor: false,
                          is_org: false,
                          handle_name: register.handle_name,
                          email: register.primary_email,
                          email_type: 0,
                          is_email_verified: false}
  end

  @doc "Register an app account for organization."
  def handle(%AppAccount{app_account_uuid: nil},
             %RegisterAppAccount{is_org: true} = register) do
    %AppAccountRegistered{app_account_uuid: register.app_account_uuid,
                          is_activated: false,
                          is_suspended: false,
                          is_employee: false,
                          is_contributor: false,
                          is_org: true,
                          handle_name: register.handle_name,
                          email: register.billing_email,
                          email_type: 1,
                          is_email_verified: false}
  end

  @doc "Update an app account handle name, email, phone, etc.."
  def handle(%AppAccount{} = app_account, %UpdateAppAccount{} = update) do
    fns = [
      &handle_name_changed/2,
      &activation_status_updated/2,
      &suspension_status_updated/2,
      &employee_status_updated/2,
      &contributor_status_updated/2,
      &primary_email_updated/2,
      &primary_email_verified/2,
      &billing_email_added/2,
      &billing_email_removed/2,
    ]
    Enum.reduce fns,
                [],
                fn change, events ->
                  case change.(app_account, update) do
                    nil ->
                      events

                    {:error, message} ->
                      {:error, message}

                    event ->
                      [event | events]
                  end
                end
  end


  defp handle_name_changed(%AppAccount{},
                           %UpdateAppAccount{handle_name: nil}) do
    nil
  end

  defp handle_name_changed(%AppAccount{}, %UpdateAppAccount{handle_name: ""}) do
    nil
  end

  defp handle_name_changed(%AppAccount{handle_name: handle_name},
                           %UpdateAppAccount{handle_name: handle_name}) do
    nil
  end

  defp handle_name_changed(%AppAccount{app_account_uuid: app_account_uuid},
                           %UpdateAppAccount{handle_name: handle_name}) do
    %AppAccountHandleNameChanged{app_account_uuid: app_account_uuid,
                                 handle_name: handle_name}
  end


  defp activation_status_updated(%AppAccount{},
                                 %UpdateAppAccount{is_activated: nil}) do
    nil
  end

  defp activation_status_updated(%AppAccount{},
                                 %UpdateAppAccount{is_activated: ""}) do
    nil
  end

  defp activation_status_updated(%AppAccount{is_activated: is_activated},
                                 %UpdateAppAccount{is_activated: is_activated}) do
    nil
  end

  defp activation_status_updated(%AppAccount{app_account_uuid: app_account_uuid},
                                 %UpdateAppAccount{is_activated: false}) do
    %AppAccountDeactivated{app_account_uuid: app_account_uuid,
                           is_activated: false}
  end

  defp activation_status_updated(%AppAccount{app_account_uuid: app_account_uuid},
                                 %UpdateAppAccount{is_activated: true}) do
    %AppAccountActivated{app_account_uuid: app_account_uuid, is_activated: true}
  end


  defp suspension_status_updated(%AppAccount{},
                                 %UpdateAppAccount{is_suspended: nil}) do
    nil
  end

  defp suspension_status_updated(%AppAccount{},
                                 %UpdateAppAccount{is_suspended: ""}) do
    nil
  end

  defp suspension_status_updated(%AppAccount{is_suspended: is_suspended},
                                 %UpdateAppAccount{is_suspended: is_suspended}) do
    nil
  end

  defp suspension_status_updated(%AppAccount{app_account_uuid: app_account_uuid},
                                 %UpdateAppAccount{is_suspended: false}) do
    %AppAccountSuspensionLifted{app_account_uuid: app_account_uuid,
                                is_suspended: false}
  end

  defp suspension_status_updated(%AppAccount{app_account_uuid: app_account_uuid},
                                 %UpdateAppAccount{is_suspended: true}) do
    %AppAccountSuspended{app_account_uuid: app_account_uuid, is_suspended: true}
  end


  defp employee_status_updated(%AppAccount{},
                               %UpdateAppAccount{is_employee: nil}) do
    nil
  end

  defp employee_status_updated(%AppAccount{},
                               %UpdateAppAccount{is_employee: ""}) do
    nil
  end

  defp employee_status_updated(%AppAccount{is_org: true},
                               %UpdateAppAccount{is_employee: _}) do
    {:error, %{app_account: ["organization cannot be an employee"]}}
  end

  defp employee_status_updated(%AppAccount{is_employee: is_employee},
                               %UpdateAppAccount{is_employee: is_employee}) do
    nil
  end

  defp employee_status_updated(%AppAccount{app_account_uuid: app_account_uuid},
                               %UpdateAppAccount{is_employee: true}) do
    %AppAccountMarkedAsEmployee{app_account_uuid: app_account_uuid,
                                is_employee: true}
  end

  defp employee_status_updated(%AppAccount{app_account_uuid: app_account_uuid},
                               %UpdateAppAccount{is_employee: false}) do
    %AppAccountMarkedAsNonEmployee{app_account_uuid: app_account_uuid,
                                   is_employee: false}
  end


  defp contributor_status_updated(%AppAccount{},
                                  %UpdateAppAccount{is_contributor: nil}) do
    nil
  end

  defp contributor_status_updated(%AppAccount{},
                                  %UpdateAppAccount{is_contributor: ""}) do
    nil
  end

  defp contributor_status_updated(%AppAccount{is_org: true},
                                  %UpdateAppAccount{is_contributor: _}) do
    {:error, %{app_account: ["organization cannot be a contributor"]}}
  end

  defp contributor_status_updated(%AppAccount{is_contributor: is_contributor},
                                  %UpdateAppAccount{is_contributor: is_contributor}) do
    nil
  end

  defp contributor_status_updated(%AppAccount{app_account_uuid: app_account_uuid},
                                  %UpdateAppAccount{is_contributor: true}) do
    %AppAccountMarkedAsContributor{app_account_uuid: app_account_uuid,
                                   is_contributor: true}
  end

  defp contributor_status_updated(%AppAccount{app_account_uuid: app_account_uuid},
                                  %UpdateAppAccount{is_contributor: false}) do
    %AppAccountMarkedAsNonContributor{app_account_uuid: app_account_uuid,
                                      is_contributor: false}
  end


  defp primary_email_updated(%AppAccount{},
                             %UpdateAppAccount{primary_email: nil}) do
    nil
  end

  defp primary_email_updated(%AppAccount{},
                             %UpdateAppAccount{primary_email: ""}) do
    nil
  end

  defp primary_email_updated(%AppAccount{is_org: true},
                             %UpdateAppAccount{primary_email: _}) do
    {:error,
     %{app_account: ["organization account does not have primary email"]}}
  end

  defp primary_email_updated(%AppAccount{app_account_uuid: app_account_uuid},
                             %UpdateAppAccount{primary_email: primary_email}) do
    %AppAccountPrimaryEmailUpdated{app_account_uuid: app_account_uuid,
                                   email_address: primary_email,
                                   is_verified: false}
  end


  defp primary_email_verified(%AppAccount{},
                              %UpdateAppAccount{primary_email_verification_code: nil}) do
    nil
  end

  defp primary_email_verified(%AppAccount{},
                              %UpdateAppAccount{primary_email_verification_code: ""}) do
    nil
  end

  defp primary_email_verified(%AppAccount{is_org: true},
                              %UpdateAppAccount{primary_email_verification_code: _}) do
    {:error,
     %{app_account: ["organization account does not have primary email"]}}
  end

  defp primary_email_verified(%AppAccount{app_account_uuid: app_account_uuid},
                              %UpdateAppAccount{primary_email_verification_code: primary_email_verification_code}) do
    case EmailVerification.get_code_hash(%{
                                           app_account_uuid: app_account_uuid,
                                           email_type: 0,
                                         }) do
      nil ->
        {:error, %{app_account: ["unable to verify primary email"]}}

      email_verification_code_hash ->
        if Crypto.verify(primary_email_verification_code,
                         email_verification_code_hash,
                         :bcrypt) do
          %AppAccountPrimaryEmailVerified{app_account_uuid: app_account_uuid,
                                          is_verified: true}
        else
          {:error, %{app_account: ["invalid primary email verification code"]}}
        end
    end
  end


  defp billing_email_added(%AppAccount{},
                           %UpdateAppAccount{new_billing_email: nil}) do
    nil
  end

  defp billing_email_added(%AppAccount{},
                           %UpdateAppAccount{new_billing_email: ""}) do
    nil
  end

  defp billing_email_added(%AppAccount{is_org: false},
                           %UpdateAppAccount{new_billing_email: _}) do
    {:error, %{app_account: ["user account does not have billing email"]}}
  end

  defp billing_email_added(%AppAccount{app_account_uuid: app_account_uuid},
                           %UpdateAppAccount{new_billing_email: new_billing_email}) do
    %AppAccountBillingEmailAdded{app_account_uuid: app_account_uuid,
                                 email_address: new_billing_email}
  end


  defp billing_email_removed(%AppAccount{},
                             %UpdateAppAccount{remove_billing_email: nil}) do
    nil
  end

  defp billing_email_removed(%AppAccount{},
                             %UpdateAppAccount{remove_billing_email: ""}) do
    nil
  end

  defp billing_email_removed(%AppAccount{is_org: false},
                             %UpdateAppAccount{remove_billing_email: _}) do
    {:error, %{app_account: ["user account does not have billing email"]}}
  end

  defp billing_email_removed(%AppAccount{app_account_uuid: app_account_uuid},
                             %UpdateAppAccount{remove_billing_email: remove_billing_email}) do
    %AppAccountBillingEmailRemoved{app_account_uuid: app_account_uuid,
                                   email_address: remove_billing_email}
  end
end
