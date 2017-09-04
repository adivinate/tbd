defmodule Plustwo.Domain.Accounts.Notifications do
  @moduledoc false

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Accounts.Schemas.Account
  alias Plustwo.Domain.Accounts.Queries.AccountQuery

  @doc "Wait until the given read model is updated to the given version."
  def wait_for(Account, uuid, version) do
    case Postgres.one(AccountQuery.by_uuid(uuid, version)) do
      nil ->
        subscribe_and_wait Account, uuid, version

      projection ->
        {:ok, projection}
    end
  end


  @doc "Publish updated account read model to interested subscribers."
  def publish_changes(%{account: %Account{} = account}) do
    publish account
  end


  def publish_changes(%{account: {_, accounts}}) when is_list(accounts) do
    Enum.each accounts, &publish/1
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
end
