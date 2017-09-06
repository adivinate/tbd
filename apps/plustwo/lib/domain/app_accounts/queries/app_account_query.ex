defmodule Plustwo.Domain.AppAccounts.Queries.AppAccountQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount

  def by_uuid(uuid) do
    where = [uuid: uuid]
    app_account_query where
  end

  def by_uuid(uuid, version) do
    where = [uuid: uuid, version: version]
    app_account_query where
  end


  def by_handle_name(handle_name) do
    where = [handle_name: handle_name]
    app_account_query where
  end


  defp app_account_query(w) do
    from AppAccount, where: ^(w)
  end
end
