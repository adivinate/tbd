defmodule Plustwo.Domain.AppUsers.Queries.AppUserQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.AppUsers.Schemas.AppUser

  def by_uuid(uuid) do
    where = [uuid: uuid]
    app_user_query where
  end

  def by_uuid(uuid, version) do
    where = [uuid: uuid, version: version]
    app_user_query where
  end


  def by_app_account_uuid(app_account_uuid) do
    where = [app_account_uuid: app_account_uuid]
    app_user_query where
  end


  defp app_user_query(w) do
    from AppUser, where: ^(w)
  end
end
