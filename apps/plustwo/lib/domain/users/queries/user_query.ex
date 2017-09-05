defmodule Plustwo.Domain.Users.Queries.UserQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.Users.Schemas.User

  def by_uuid(uuid) do
    where = [uuid: uuid]
    user_query where
  end

  def by_uuid(uuid, version) do
    where = [uuid: uuid, version: version]
    user_query where
  end


  def by_handle_name(handle_name) do
    where = [handle_name: handle_name]
    user_query where
  end


  def by_account_uuid(account_uuid) do
    where = [account_uuid: account_uuid]
    user_query where
  end


  defp user_query(w) do
    from User, where: ^(w)
  end
end
