defmodule Plustwo.Domain.AppOrgs.Queries.AppOrgQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.AppOrgs.Schemas.AppOrg

  def by_uuid(uuid) do
    where = [uuid: uuid]
    app_org_query where
  end

  def by_uuid(uuid, version) do
    where = [uuid: uuid, version: version]
    app_org_query where
  end


  def by_app_account_uuid(app_account_uuid) do
    where = [app_account_uuid: app_account_uuid]
    app_org_query where
  end


  defp app_org_query(w) do
    from AppOrg, where: ^(w)
  end
end
