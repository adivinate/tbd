defmodule Plustwo.Domain.Accounts.Workflows.SendPrimaryEmailVerificationCode do
  @moduledoc "Send primary email verification code when a user account is registered."

  use Commanded.Event.Handler,
      name: "Accounts.Workflows.SendEmailVerificationCode"

  import Ecto.Changeset

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Infrastructure.Components.Crypto
  alias Plustwo.Domain.Accounts.Schemas.AccountPrimaryEmailVerificationCode
  alias Plustwo.Domain.Accounts.Events.AccountRegistered

  def handle(%AccountRegistered{uuid: uuid, email: email, is_org: false},
             _metadata) do
    verification_code = UUID.uuid4(:hex)
    case set_account_email_verification_code(%{
                                               account_uuid: uuid,
                                               verification_code: verification_code,
                                             }) do
      {:error, _} ->
        :ok

      _ ->
        :ok
    end
  end


  ##########
  # Private Helpers
  ##########
  defp hash_verification_code(%{verification_code: verification_code} = code) do
    code
    |> Map.put(:verification_code_hash, Crypto.hash(verification_code, :bcrypt))
    |> Map.delete(:verification_code)
  end


  defp changeset(%AccountPrimaryEmailVerificationCode{} = changeset, attrs) do
    changeset
    |> cast(attrs, ~w(account_uuid verification_code_hash))
    |> validate_required([:account_uuid, :verification_code_hash])
    |> foreign_key_constraint(:account_uuid)
  end


  defp set_account_email_verification_code(attrs) do
    %AccountPrimaryEmailVerificationCode{}
    |> changeset(hash_verification_code(attrs))
    |> Postgres.insert_or_update()
  end
end
