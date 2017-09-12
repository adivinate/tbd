defmodule Plustwo.Domain.AppAccounts.Workflows.SendPrimaryEmailVerificationCode do
  @moduledoc "Send primary email verification code when a user app account is registered."

  use Commanded.Event.Handler,
      name: "AppAccounts.Workflows.SendEmailVerificationCode"

  alias Plustwo.Infrastructure.Components.EmailVerification
  alias Plustwo.Domain.AppAccounts.Events.AppAccountRegistered

  def handle(%AppAccountRegistered{app_account_uuid: app_account_uuid,
                                   email_address: email_address,
                                   type: 0},
             _metadata) do
    verification_code = generate_verification_code()
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


  defp generate_verification_code do
    if Mix.env() == :dev or Mix.env() == :test do
      "email_code"
    else
      UUID.uuid4 :hex
    end
  end
end
