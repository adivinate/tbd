defmodule Plustwo.Application.Resolvers.AppAccount do
  @moduledoc false

  alias Plustwo.Domain.AppAccounts

  def find(_parent, %{uuid: uuid}, _info) do
    case AppAccounts.get_app_account_by_uuid(uuid) do
      nil ->
        {:error, "app account with UUID #{uuid} not found"}

      account ->
        {:ok, account}
    end
  end
end
