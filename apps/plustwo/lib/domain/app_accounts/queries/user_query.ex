defmodule Plustwo.Domain.AppAccounts.Queries.UserQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.AppAccounts.Schemas.User

  def by_uuid(uuid) do
    where = [uuid: uuid]
    user_query where
  end

  def by_uuid(uuid, version) do
    where = [uuid: uuid, version: version]
    user_query where
  end


  def by_app_account_uuid(app_account_uuid) do
    where = [app_account_uuid: app_account_uuid]
    user_query where
  end


  defp user_query(w) do
    from User, where: ^(w)
  end
end
