defmodule Plustwo.Domain.AppAccounts.Workflows.SendPrimaryEmailVerificationCode do
  @moduledoc "Send primary email verification code when a user app account is registered."

  use Commanded.Event.Handler,
      name: "AppAccounts.Workflows.SendEmailVerificationCode"

  import Ecto.Changeset

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Infrastructure.Components.Crypto
  alias Plustwo.Domain.AppAccounts.Schemas.AppAccountPrimaryEmailVerificationCode
  alias Plustwo.Domain.AppAccounts.Events.AppAccountRegistered

  def handle(%AppAccountRegistered{uuid: uuid, email: email, is_org: false},
             _metadata) do
    verification_code = UUID.uuid4(:hex)
    case set_primary_email_verification_code(%{
                                               app_account_uuid: uuid,
                                               verification_code: verification_code,
                                             }) do
      {:ok, _primary_email_verification_code} ->
        :ok

      _ ->
        {:error, "unable to send primary email verification code"}
    end
  end


  defp hash_verification_code(%{verification_code: verification_code} = code) do
    code
    |> Map.put(:verification_code_hash, Crypto.hash(verification_code, :bcrypt))
    |> Map.delete(:verification_code)
  end


  defp changeset(%AppAccountPrimaryEmailVerificationCode{} = changeset,
                 attrs) do
    changeset
    |> cast(attrs, ~w(app_account_uuid verification_code_hash))
    |> validate_required([:app_account_uuid, :verification_code_hash])
    |> foreign_key_constraint(:app_account_uuid)
  end


  defp set_primary_email_verification_code(attrs) do
    %AppAccountPrimaryEmailVerificationCode{}
    |> changeset(hash_verification_code(attrs))
    |> Postgres.insert_or_update()
  end
end
