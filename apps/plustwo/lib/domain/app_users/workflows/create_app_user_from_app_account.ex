defmodule Plustwo.Domain.AppUsers.Workflows.CreateAppUserFromAppAccount do
  @moduledoc false

  use Commanded.Event.Handler,
      name: "AppUsers.Workflows.CreateAppUserFromAppAccount"

  alias Plustwo.Domain.Router
  alias Plustwo.Domain.AppAccounts.Events.AppAccountRegistered
  alias Plustwo.Domain.AppUsers.Notifications
  alias Plustwo.Domain.AppUsers.Schemas.AppUser
  alias Plustwo.Domain.AppUsers.Commands.CreateAppUser

  def handle(%AppAccountRegistered{app_account_uuid: app_account_uuid, is_org: false},
             _metadata) do
    case create_app_user(%{app_account_uuid: app_account_uuid}) do
      {:ok, _app_user} ->
        :ok

      _ ->
        {:error, "unable to create app user"}
    end
  end


  defp create_app_user(attrs) do
    app_user_uuid = UUID.uuid4()
    command =
      attrs
      |> CreateAppUser.new()
      |> CreateAppUser.assign_app_user_uuid(app_user_uuid)
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for AppUser, app_user_uuid, version
    else
      reply ->
        reply
    end
  end
end
