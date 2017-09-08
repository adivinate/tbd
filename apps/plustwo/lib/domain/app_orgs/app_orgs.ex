defmodule Plustwo.Domain.AppOrgs do
  @moduledoc false

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Router
  alias Plustwo.Domain.AppAccounts.Schemas.AppAccount
  alias Plustwo.Domain.AppOrgs.Schemas.{AppOrg, AppOrgMember}
  alias Plustwo.Domain.AppOrgs.Notifications
  alias Plustwo.Domain.AppOrgs.Schemas.AppOrg
  alias Plustwo.Domain.AppOrgs.Queries.{AppOrgQuery, AppOrgMemberQuery}
  alias Plustwo.Domain.AppOrgs.Commands.{CreateAppOrg,
                                         UpdateAppOrgMember,
                                         UpdateAppOrg}

  @doc "Creates an app organization on Plustwo."
  def create_app_org(attrs \\ %{}) do
    app_org_uuid = UUID.uuid4()
    command =
      attrs
      |> CreateAppOrg.new()
      |> CreateAppOrg.assign_app_org_uuid(app_org_uuid)
      |> CreateAppOrg.assign_app_account_uuid(attrs.app_account_uuid)
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for AppOrg, app_org_uuid, version
    else
      reply ->
        reply
    end
  end


  @doc "Updates metadata of an app organization."
  def update_app_org(%AppOrg{uuid: app_org_uuid}, attrs \\ %{}) do
    command =
      attrs
      |> UpdateAppOrg.new()
      |> UpdateAppOrg.assign_app_org_uuid(app_org_uuid)
      |> UpdateAppOrg.downcase_email_address()
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for AppOrg, app_org_uuid, version
    else
      reply ->
        reply
    end
  end


  @doc "Updates attributes of an app organization member."
  def update_app_org_member(%AppOrg{uuid: app_org_uuid},
                            %AppAccount{uuid: app_account_uuid},
                            attrs) do
    command =
      attrs
      |> UpdateAppOrgMember.new()
      |> UpdateAppOrgMember.assign_app_org_uuid(app_org_uuid)
      |> UpdateAppOrgMember.assign_app_account_uuid(app_account_uuid)
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for AppOrgMember,
                             app_org_uuid,
                             app_account_uuid,
                             version
    else
      reply ->
        reply
    end
  end


  @doc "Adds a new member to an app organization."
  def add_new_app_org_member(%AppOrg{uuid: app_org_uuid},
                             %AppAccount{uuid: app_account_uuid}) do
    command =
      %{is_new: true}
      |> UpdateAppOrgMember.new()
      |> UpdateAppOrgMember.assign_app_org_uuid(app_org_uuid)
      |> UpdateAppOrgMember.assign_app_account_uuid(app_account_uuid)
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for AppOrgMember,
                             app_org_uuid,
                             app_account_uuid,
                             version
    else
      reply ->
        reply
    end
  end


  @doc "Removes a member from an app organization."
  def remove_app_org_member(%AppOrg{uuid: app_org_uuid},
                            %AppAccount{uuid: app_account_uuid}) do
    %{is_remove: true}
    |> UpdateAppOrgMember.new()
    |> UpdateAppOrgMember.assign_app_org_uuid(app_org_uuid)
    |> UpdateAppOrgMember.assign_app_account_uuid(app_account_uuid)
    |> Router.dispatch()
  end


  @doc "Retrieves an app organization by UUID, or return `nil` if not found."
  def get_app_org_by_uuid(app_org_uuid) do
    app_org_uuid
    |> AppOrgQuery.by_uuid()
    |> Postgres.one()
  end


  @doc "Retrieves an app organization member, or return `nil` if not found."
  def get_app_org_member(app_org_uuid, app_account_uuid) do
    app_org_uuid
    |> AppOrgMemberQuery.by_app_org_uuid(app_account_uuid)
    |> Postgres.one()
  end
end
