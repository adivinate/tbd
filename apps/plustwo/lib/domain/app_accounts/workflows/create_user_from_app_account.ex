defmodule Plustwo.Domain.AppAccounts.Workflows.CreateUserFromAppAccount do
  @moduledoc false

  use Commanded.Event.Handler,
      name: "AppAccounts.Workflows.CreateUserFromAppAccount"

  alias Plustwo.Domain.Router
  alias Plustwo.Domain.AppAccounts.Events.AppAccountRegistered
  alias Plustwo.Domain.AppAccounts.Notifications
  alias Plustwo.Domain.AppAccounts.Schemas.User
  alias Plustwo.Domain.AppAccounts.Commands.CreateUser

  def handle(%AppAccountRegistered{app_account_uuid: app_account_uuid, type: 0},
             _metadata) do
    case create_user(%{app_account_uuid: app_account_uuid}) do
      {:ok, _user} ->
        :ok

      _ ->
        {:error, "unable to create user"}
    end
  end


  defp create_user(%{app_account_uuid: app_account_uuid} = attrs) do
    user_uuid = UUID.uuid4()
    command =
      attrs
      |> CreateUser.new()
      |> CreateUser.assign_user_uuid(user_uuid)
      |> CreateUser.assign_app_account_uuid(app_account_uuid)
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for User, user_uuid, version
    else
      reply ->
        reply
    end
  end
end
