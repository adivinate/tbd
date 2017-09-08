defmodule Plustwo.Domain.AppOrgs.Queries.AppOrgMemberQuery do
  @moduledoc false

  use Plustwo.Domain, :query

  alias Plustwo.Domain.AppOrgs.Schemas.AppOrgMember

  def by_app_account_uuid(app_account_uuid) do
    where = [app_account_uuid: app_account_uuid]
    app_org_member_query where
  end


  def by_app_org_uuid(app_org_uuid) do
    where = [app_org_uuid: app_org_uuid]
    app_org_member_query where
  end

  def by_app_org_uuid(app_org_uuid, app_account_uuid) do
    where = [app_org_uuid: app_org_uuid, app_account_uuid: app_account_uuid]
    app_org_member_query where
  end

  def by_app_org_uuid(app_org_uuid, app_account_uuid, version) do
    where = [
      app_org_uuid: app_org_uuid,
      app_account_uuid: app_account_uuid,
      version: version,
    ]
    app_org_member_query where
  end


  defp app_org_member_query(w) do
    from AppOrgMember, where: ^(w)
  end
end
