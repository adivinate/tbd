defmodule Plustwo.Domain.AppAccounts.Workflows.SendPrimaryEmailVerificationCode do
  @moduledoc "Send primary email verification code when a user app account is registered."

  use Commanded.Event.Handler,
      name: "AppAccounts.Workflows.SendEmailVerificationCode"

  alias Plustwo.Infrastructure.Components.EmailVerification
  alias Plustwo.Domain.AppAccounts.Events.AppAccountRegistered

  def handle(%AppAccountRegistered{app_account_uuid: app_account_uuid, email: email, is_org: false},
             _metadata) do
    verification_code = UUID.uuid4(:hex)
    case EmailVerification.set_code(%{
                                      app_account_uuid: app_account_uuid,
                                      email_type: 0,
                                      code: verification_code,
                                    }) do
      {:ok, _primary_email_verification_code} ->
        :ok

      _ ->
        {:error, "unable to send primary email verification code"}
    end
  end
end
