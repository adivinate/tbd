defmodule Plustwo.Application.Resolvers.Account do
  @moduledoc false

  alias Plustwo.Domain.Accounts

  def find(_parent, %{uuid: uuid}, _info) do
    case Accounts.get_account_by_uuid(uuid) do
      nil  -> {:error, "Account with UUID #{uuid} not found"}
      account -> {:ok, account}
    end
  end
end
