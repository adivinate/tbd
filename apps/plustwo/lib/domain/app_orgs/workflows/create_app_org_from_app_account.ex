defmodule Plustwo.Domain.AppOrgs.Workflows.CreateAppOrgFromAppAccount do
  @moduledoc false

  use Commanded.Event.Handler,
      name: "AppOrgs.Workflows.CreateAppOrgFromAppAccount"

  alias Plustwo.Domain.Router
  alias Plustwo.Domain.AppAccounts.Events.AppAccountRegistered
  alias Plustwo.Domain.AppOrgs.Notifications
  alias Plustwo.Domain.AppOrgs.Schemas.AppOrg
  alias Plustwo.Domain.AppOrgs.Commands.CreateAppOrg

  def handle(%AppAccountRegistered{app_account_uuid: app_account_uuid,
                                   is_org: true},
             _metadata) do
    case create_app_org(%{app_account_uuid: app_account_uuid, type: 0}) do
      {:ok, _app_org} ->
        :ok

      _ ->
        {:error, "unable to create app org"}
    end
  end


  defp create_app_org(attrs) do
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
end
