defmodule Plustwo.Domain.AppOrgs.Notifications do
  @moduledoc false

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.AppOrgs.Schemas.{AppOrg, AppOrgMember}
  alias Plustwo.Domain.AppOrgs.Queries.{AppOrgQuery, AppOrgMemberQuery}

  @doc "Waits until the given read model is updated to the given version."
  def wait_for(AppOrg, app_org_uuid, version) do
    case Postgres.one(AppOrgQuery.by_uuid(app_org_uuid, version)) do
      nil ->
        subscribe_and_wait AppOrg, app_org_uuid, version

      projection ->
        {:ok, projection}
    end
  end

  def wait_for(AppOrgMember, app_org_uuid, app_account_uuid, version) do
    case Postgres.one(AppOrgMemberQuery.by_app_org_uuid(app_org_uuid,
                                                        app_account_uuid,
                                                        version)) do
      nil ->
        subscribe_and_wait AppOrgMember,
                           app_org_uuid,
                           app_account_uuid,
                           version

      projection ->
        {:ok, projection}
    end
  end


  @doc "Publishes updated account read model to interested subscribers."
  def publish_changes(%{app_org: %AppOrg{} = app_org}) do
    publish app_org
  end


  def publish_changes(%{app_org: {_, app_orgs}}) when is_list(app_orgs) do
    Enum.each app_orgs, &publish/1
  end


  def publish_changes(%{app_org_member: %AppOrgMember{} = app_org_member}) do
    publish app_org_member
  end


  def publish_changes(%{app_org_member: {_, app_org_members}})
      when is_list(app_org_members) do
    Enum.each app_org_members, &publish/1
  end


  defp publish(%AppOrg{uuid: app_org_uuid, version: version} = app_org) do
    Registry.dispatch Plustwo.Domain.AppOrgs,
                      {AppOrg, app_org_uuid, version},
                      fn entries ->
                        for {pid, _} <- entries do
                          send pid, {AppOrg, app_org}
                        end
                      end
  end

  defp publish(%AppOrgMember{app_org_uuid: app_org_uuid,
                             app_account_uuid: app_account_uuid,
                             version: version} =
                 app_org_member) do
    Registry.dispatch Plustwo.Domain.AppOrgs,
                      {AppOrgMember, app_org_uuid, app_account_uuid, version},
                      fn entries ->
                        for {pid, _} <- entries do
                          send pid, {AppOrgMember, app_org_member}
                        end
                      end
  end


  defp subscribe_and_wait(AppOrg, app_org_uuid, version) do
    Registry.register Plustwo.Domain.AppOrgs,
                      {AppOrg, app_org_uuid, version},
                      []
    receive do
      {AppOrg, projection} ->
        {:ok, projection}
    after
      5000 ->
        {:error, :timeout}
    end
  end

  defp subscribe_and_wait(AppOrgMember,
                          app_org_uuid,
                          app_account_uuid,
                          version) do
    Registry.register Plustwo.Domain.AppOrgs,
                      {AppOrgMember,
                       app_org_uuid,
                       app_account_uuid,
                       version},
                      []
    receive do
      {AppOrgMember, projection} ->
        {:ok, projection}
    after
      5000 ->
        {:error, :timeout}
    end
  end
end
