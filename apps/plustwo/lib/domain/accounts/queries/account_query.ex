defmodule Plustwo.Domain.Accounts.Queries.AccountQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.Accounts.Schemas.Account

  def by_uuid(uuid) do
    where = [uuid: uuid]
    account_query where
  end

  def by_uuid(uuid, version) do
    where = [uuid: uuid, version: version]
    account_query where
  end


  def by_handle_name(handle_name) do
    where = [handle_name: handle_name]
    account_query where
  end


  defp account_query(w) do
    from Account, preload: [:emails], where: ^(w)
  end
end
