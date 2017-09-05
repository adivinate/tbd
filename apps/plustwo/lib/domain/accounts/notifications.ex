defmodule Plustwo.Domain.Accounts.Notifications do
  @moduledoc false

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Accounts.Schemas.{Account, AccountEmail}
  alias Plustwo.Domain.Accounts.Queries.{AccountQuery, AccountEmailQuery}

  @doc "Waits until the given read model is updated to the given version."
  def wait_for(Account, uuid, version) do
    case Postgres.one(AccountQuery.by_uuid(uuid, version)) do
      nil ->
        subscribe_and_wait Account, uuid, version

      projection ->
        {:ok, projection}
    end
  end

  def wait_for(AccountEmail,
               account_uuid,
               email_address,
               email_type,
               version) do
    case Postgres.one(AccountEmailQuery.by_account_uuid(account_uuid,
                                                        email_address,
                                                        email_type,
                                                        version)) do
      nil ->
        subscribe_and_wait AccountEmail,
                           account_uuid,
                           email_address,
                           email_type,
                           version

      projection ->
        {:ok, projection}
    end
  end


  @doc "Publishes updated account read model to interested subscribers."
  def publish_changes(%{account: %Account{} = account}) do
    publish account
  end


  def publish_changes(%{account: {_, accounts}}) when is_list(accounts) do
    Enum.each accounts, &publish/1
  end


  def publish_changes(%{account_email: %AccountEmail{} = account_email}) do
    publish account_email
  end


  def publish_changes(%{account_email: {_, account_emails}})
      when is_list(account_emails) do
    Enum.each account_emails, &publish/1
  end


  ##########
  # Private Helpers
  ##########
  defp publish(%Account{uuid: uuid, version: version} = account) do
    Registry.dispatch Plustwo.Domain.Accounts,
                      {Account, uuid, version},
                      fn entries ->
                        for {pid, _} <- entries do
                          send pid, {Account, account}
                        end
                      end
  end

  defp publish(%AccountEmail{account_uuid: account_uuid,
                             address: email_address,
                             type: email_type,
                             version: version} =
                 account_email) do
    Registry.dispatch Plustwo.Domain.Accounts,
                      {AccountEmail,
                       account_uuid,
                       email_address,
                       email_type,
                       version},
                      fn entries ->
                        for {pid, _} <- entries do
                          send pid, {AccountEmail, account_email}
                        end
                      end
  end


  defp subscribe_and_wait(Account, uuid, version) do
    Registry.register Plustwo.Domain.Accounts, {Account, uuid, version}, []
    receive do
      {Account, projection} ->
        {:ok, projection}
    after
      5000 ->
        {:error, :timeout}
    end
  end

  defp subscribe_and_wait(AccountEmail,
                          account_uuid,
                          email_address,
                          email_type,
                          version) do
    Registry.register Plustwo.Domain.Accounts,
                      {AccountEmail,
                       account_uuid,
                       email_address,
                       email_type,
                       version},
                      []
    receive do
      {AccountEmail, projection} ->
        {:ok, projection}
    after
      5000 ->
        {:error, :timeout}
    end
  end
end
