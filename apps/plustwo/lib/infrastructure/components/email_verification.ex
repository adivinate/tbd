defmodule Plustwo.Infrastructure.Components.EmailVerification do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount
  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Infrastructure.Components.Crypto
  alias Plustwo.Infrastructure.Components.EmailVerification

  schema "email_verification" do
    belongs_to :account,
               AppAccount,
               foreign_key: :app_account_uuid,
               references: :uuid,
               type: :binary_id
    field :email_type, :integer
    field :code_hash, :string
  end

  @doc "Set email verification code."
  def set_code(attrs) do
    %EmailVerification{}
    |> changeset(hash_code(attrs))
    |> Postgres.insert_or_update()
  end


  @doc "Get hashed email verification code."
  def get_code_hash(%{
                      app_account_uuid: app_account_uuid,
                      email_type: email_type,
                    }) do
    case Postgres.get_by(EmailVerification,
                         app_account_uuid: app_account_uuid,
                         email_type: email_type) do
      nil ->
        nil

      email_verification_code ->
        Map.get email_verification_code, :code_hash
    end
  end


  defp hash_code(%{code: code} = verification) do
    verification
    |> Map.put(:code_hash, Crypto.hash(code, :bcrypt))
    |> Map.delete(:code)
  end


  defp changeset(%EmailVerification{} = changeset, attrs) do
    changeset
    |> cast(attrs, ~w(app_account_uuid email_type code_hash))
    |> validate_required([:app_account_uuid, :email_type, :code_hash])
    |> foreign_key_constraint(:app_account_uuid)
  end
end
