defmodule Plustwo.Domain.Accounts.CommandHandlers.AccountHandler do
  @moduledoc false

  @behaviour Commanded.Commands.Handler
  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Infrastructure.Components.Crypto
  alias Plustwo.Domain.Accounts.Aggregates.Account
  alias Plustwo.Domain.Accounts.Schemas.AccountPrimaryEmailVerificationCode
  alias Plustwo.Domain.Accounts.Commands.{RegisterAccount, UpdateAccount}
  alias Plustwo.Domain.Accounts.Events.{AccountActivated,
                                        AccountBillingEmailAdded,
                                        AccountBillingEmailRemoved,
                                        AccountDeactivated,
                                        AccountHandleNameChanged,
                                        AccountMarkedAsContributor,
                                        AccountMarkedAsEmployee,
                                        AccountMarkedAsNonEmployee,
                                        AccountMarkedAsNonContributor,
                                        AccountPrimaryEmailUpdated,
                                        AccountPrimaryEmailVerified,
                                        AccountRegistered,
                                        AccountSuspended,
                                        AccountSuspensionLifted}

  ##########
  # Handlers
  ##########
  @doc "Register an account for user."
  def handle(%Account{uuid: nil}, %RegisterAccount{is_org: false} = register) do
    %AccountRegistered{uuid: register.uuid,
                       is_activated: true,
                       is_suspended: false,
                       is_employee: false,
                       is_contributor: false,
                       is_org: false,
                       handle_name: register.handle_name,
                       email: register.email,
                       email_type: 0,
                       is_email_verified: false}
  end

  @doc "Register an account for organization."
  def handle(%Account{uuid: nil}, %RegisterAccount{is_org: true} = register) do
    %AccountRegistered{uuid: register.uuid,
                       is_activated: false,
                       is_suspended: false,
                       is_employee: false,
                       is_contributor: false,
                       is_org: true,
                       handle_name: register.handle_name,
                       email: register.email,
                       email_type: 1,
                       is_email_verified: false}
  end

  @doc "Update an account handle name, email, phone, etc.."
  def handle(%Account{} = user, %UpdateAccount{} = update) do
    fns = [
      &account_handle_name_changed/2,
      &account_activation_status_updated/2,
      &account_suspension_status_updated/2,
      &account_employee_status_updated/2,
      &account_contributor_status_updated/2,
      &account_primary_email_updated/2,
      &account_primary_email_verified/2,
      &account_billing_email_updated/2,
    ]
    Enum.reduce fns, [], fn change, events -> case change.(user, update) do
                    nil ->
                      events

                    {:error, message} ->
                      {:error, message}

                    event ->
                      [event | events]
                  end end
  end


  ##########
  # Private helpers
  ##########
  defp account_handle_name_changed(%Account{},
                                   %UpdateAccount{handle_name: nil}) do
    nil
  end

  defp account_handle_name_changed(%Account{},
                                   %UpdateAccount{handle_name: ""}) do
    nil
  end

  defp account_handle_name_changed(%Account{handle_name: handle_name},
                                   %UpdateAccount{handle_name: handle_name}) do
    nil
  end

  defp account_handle_name_changed(%Account{uuid: uuid},
                                   %UpdateAccount{handle_name: handle_name}) do
    %AccountHandleNameChanged{uuid: uuid, handle_name: handle_name}
  end


  defp account_activation_status_updated(%Account{},
                                         %UpdateAccount{is_activated: nil}) do
    nil
  end

  defp account_activation_status_updated(%Account{},
                                         %UpdateAccount{is_activated: ""}) do
    nil
  end

  defp account_activation_status_updated(%Account{is_activated: is_activated},
                                         %UpdateAccount{is_activated: is_activated}) do
    nil
  end

  defp account_activation_status_updated(%Account{uuid: uuid},
                                         %UpdateAccount{is_activated: false}) do
    %AccountDeactivated{uuid: uuid, is_activated: false}
  end

  defp account_activation_status_updated(%Account{uuid: uuid},
                                         %UpdateAccount{is_activated: true}) do
    %AccountActivated{uuid: uuid, is_activated: true}
  end


  defp account_suspension_status_updated(%Account{},
                                         %UpdateAccount{is_suspended: nil}) do
    nil
  end

  defp account_suspension_status_updated(%Account{},
                                         %UpdateAccount{is_suspended: ""}) do
    nil
  end

  defp account_suspension_status_updated(%Account{is_suspended: is_suspended},
                                         %UpdateAccount{is_suspended: is_suspended}) do
    nil
  end

  defp account_suspension_status_updated(%Account{uuid: uuid},
                                         %UpdateAccount{is_suspended: false}) do
    %AccountSuspensionLifted{uuid: uuid, is_suspended: false}
  end

  defp account_suspension_status_updated(%Account{uuid: uuid},
                                         %UpdateAccount{is_suspended: true}) do
    %AccountSuspended{uuid: uuid, is_suspended: true}
  end


  defp account_employee_status_updated(%Account{},
                                       %UpdateAccount{is_employee: nil}) do
    nil
  end

  defp account_employee_status_updated(%Account{},
                                       %UpdateAccount{is_employee: ""}) do
    nil
  end

  defp account_employee_status_updated(%Account{is_org: true},
                                       %UpdateAccount{is_employee: _}) do
    {:error, "organization cannot be an employee"}
  end

  defp account_employee_status_updated(%Account{is_employee: is_employee},
                                       %UpdateAccount{is_employee: is_employee}) do
    nil
  end

  defp account_employee_status_updated(%Account{uuid: uuid},
                                       %UpdateAccount{is_employee: true}) do
    %AccountMarkedAsEmployee{uuid: uuid, is_employee: true}
  end

  defp account_employee_status_updated(%Account{uuid: uuid},
                                       %UpdateAccount{is_employee: false}) do
    %AccountMarkedAsNonEmployee{uuid: uuid, is_employee: false}
  end


  defp account_contributor_status_updated(%Account{},
                                          %UpdateAccount{is_contributor: nil}) do
    nil
  end

  defp account_contributor_status_updated(%Account{},
                                          %UpdateAccount{is_contributor: ""}) do
    nil
  end

  defp account_contributor_status_updated(%Account{is_org: true},
                                          %UpdateAccount{is_contributor: _}) do
    {:error, "organization cannot be a contributor"}
  end

  defp account_contributor_status_updated(%Account{is_contributor: is_contributor},
                                          %UpdateAccount{is_contributor: is_contributor}) do
    nil
  end

  defp account_contributor_status_updated(%Account{uuid: uuid},
                                          %UpdateAccount{is_contributor: true}) do
    %AccountMarkedAsContributor{uuid: uuid, is_contributor: true}
  end

  defp account_contributor_status_updated(%Account{uuid: uuid},
                                          %UpdateAccount{is_contributor: false}) do
    %AccountMarkedAsNonContributor{uuid: uuid, is_contributor: false}
  end


  defp account_primary_email_updated(%Account{},
                                     %UpdateAccount{primary_email: nil}) do
    nil
  end

  defp account_primary_email_updated(%Account{},
                                     %UpdateAccount{primary_email: ""}) do
    nil
  end

  defp account_primary_email_updated(%Account{is_org: true},
                                     %UpdateAccount{primary_email: _}) do
    {:error, "organization account does not have primary email"}
  end

  defp account_primary_email_updated(%Account{uuid: uuid},
                                     %UpdateAccount{primary_email: primary_email}) do
    %AccountPrimaryEmailUpdated{uuid: uuid,
                                primary_email: primary_email,
                                is_primary_email_verified: false}
  end


  defp account_primary_email_verified(%Account{},
                                      %UpdateAccount{primary_email_verification_code: nil}) do
    nil
  end

  defp account_primary_email_verified(%Account{},
                                      %UpdateAccount{primary_email_verification_code: ""}) do
    nil
  end

  defp account_primary_email_verified(%Account{is_org: true},
                                      %UpdateAccount{primary_email_verification_code: _}) do
    {:error, "organization account does not have primary email"}
  end

  defp account_primary_email_verified(%Account{uuid: uuid},
                                      %UpdateAccount{primary_email_verification_code: primary_email_verification_code}) do
    case get_primary_email_verification_code_hash_by_account_uuid(uuid) do
      nil ->
        {:error, "unable to verify email verification code"}

      email_verification_code_hash ->
        if Crypto.verify(primary_email_verification_code,
                         email_verification_code_hash,
                         :bcrypt) do
          %AccountPrimaryEmailVerified{uuid: uuid,
                                       is_primary_email_verified: true}
        else
          {:error, "invalid email verification code"}
        end
    end
  end


  defp account_billing_email_updated(%Account{},
                                     %UpdateAccount{new_billing_email: nil}) do
    nil
  end

  defp account_billing_email_updated(%Account{},
                                     %UpdateAccount{new_billing_email: ""}) do
    nil
  end

  defp account_billing_email_updated(%Account{},
                                     %UpdateAccount{remove_billing_email: nil}) do
    nil
  end

  defp account_billing_email_updated(%Account{},
                                     %UpdateAccount{remove_billing_email: ""}) do
    nil
  end

  defp account_billing_email_updated(%Account{is_org: false},
                                     %UpdateAccount{new_billing_email: _}) do
    {:error, "user account does not have billing email"}
  end

  defp account_billing_email_updated(%Account{is_org: false},
                                     %UpdateAccount{remove_billing_email: _}) do
    {:error, "user_account does not have billing email"}
  end

  defp account_billing_email_updated(%Account{uuid: uuid},
                                     %UpdateAccount{new_billing_email: new_billing_email}) do
    %AccountBillingEmailAdded{uuid: uuid, billing_email: new_billing_email}
  end

  defp account_billing_email_updated(%Account{uuid: uuid},
                                     %UpdateAccount{remove_billing_email: remove_billing_email}) do
    %AccountBillingEmailRemoved{uuid: uuid, billing_email: remove_billing_email}
  end


  # Retrieves primary email verification code hash by account UUID,
  # or return `nil` if not found.
  defp get_primary_email_verification_code_hash_by_account_uuid(account_uuid) do
    case Postgres.get_by(AccountPrimaryEmailVerificationCode,
                         account_uuid: account_uuid) do
      nil ->
        nil

      email_verification_code ->
        Map.get email_verification_code, :verification_code_hash
    end
  end
end
