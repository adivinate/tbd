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
                                           AppAccountPrimaryEmailUpdated,
                                           AppAccountPrimaryEmailVerified,
                                           AppAccountRegistered,
                                           AppAccountSuspended,
                                           AppAccountSuspensionLifted}

  @doc "Register an app account for user."
  def handle(%AppAccount{app_account_uuid: nil},
             %RegisterAppAccount{type: 0} = register) do
    %AppAccountRegistered{app_account_uuid: register.app_account_uuid,
                          type: 0,
                          is_activated: true,
                          is_suspended: false,
                          handle_name: register.handle_name,
                          email_address: register.primary_email,
                          email_type: 0,
                          joined_at: Calendar.DateTime.now_utc()}
  end

  @doc "Register an app account for business."
  def handle(%AppAccount{app_account_uuid: nil},
             %RegisterAppAccount{type: 1} = register) do
    %AppAccountRegistered{app_account_uuid: register.app_account_uuid,
                          type: 1,
                          is_activated: false,
                          is_suspended: false,
                          handle_name: register.handle_name,
                          email_address: register.billing_email,
                          email_type: 1,
                          joined_at: Calendar.DateTime.now_utc()}
  end

  @doc "Update an app account handle name, email, phone, etc.."
  def handle(%AppAccount{} = app_account, %UpdateAppAccount{} = update) do
    fns = [
      &handle_name_changed/2,
      &activation_status_updated/2,
      &suspension_status_updated/2,
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
    %AppAccountDeactivated{app_account_uuid: app_account_uuid}
  end

  defp activation_status_updated(%AppAccount{app_account_uuid: app_account_uuid},
                                 %UpdateAppAccount{is_activated: true}) do
    %AppAccountActivated{app_account_uuid: app_account_uuid}
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
    %AppAccountSuspensionLifted{app_account_uuid: app_account_uuid}
  end

  defp suspension_status_updated(%AppAccount{app_account_uuid: app_account_uuid},
                                 %UpdateAppAccount{is_suspended: true}) do
    %AppAccountSuspended{app_account_uuid: app_account_uuid}
  end


  defp primary_email_updated(%AppAccount{},
                             %UpdateAppAccount{primary_email: nil}) do
    nil
  end

  defp primary_email_updated(%AppAccount{},
                             %UpdateAppAccount{primary_email: ""}) do
    nil
  end

  defp primary_email_updated(%AppAccount{type: 1},
                             %UpdateAppAccount{primary_email: _}) do
    {:error, %{app_account: ["business app account cannot have primary email"]}}
  end

  defp primary_email_updated(%AppAccount{app_account_uuid: app_account_uuid},
                             %UpdateAppAccount{primary_email: primary_email}) do
    %AppAccountPrimaryEmailUpdated{app_account_uuid: app_account_uuid,
                                   email_address: primary_email}
  end


  defp primary_email_verified(%AppAccount{},
                              %UpdateAppAccount{primary_email_verification_code: nil}) do
    nil
  end

  defp primary_email_verified(%AppAccount{},
                              %UpdateAppAccount{primary_email_verification_code: ""}) do
    nil
  end

  defp primary_email_verified(%AppAccount{type: 1},
                              %UpdateAppAccount{primary_email_verification_code: _}) do
    {:error,
     %{app_account: ["organization app account cannot have primary email"]}}
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
          %AppAccountPrimaryEmailVerified{app_account_uuid: app_account_uuid}
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

  defp billing_email_added(%AppAccount{type: 0},
                           %UpdateAppAccount{new_billing_email: _}) do
    {:error, %{app_account: ["user app account cannot have billing email"]}}
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

  defp billing_email_removed(%AppAccount{type: 0},
                             %UpdateAppAccount{remove_billing_email: _}) do
    {:error, %{app_account: ["user app account cannot have billing email"]}}
  end

  defp billing_email_removed(%AppAccount{app_account_uuid: app_account_uuid},
                             %UpdateAppAccount{remove_billing_email: remove_billing_email}) do
    %AppAccountBillingEmailRemoved{app_account_uuid: app_account_uuid,
                                   email_address: remove_billing_email}
  end
end
