defmodule Plustwo.Domain.Users.Workflows.CreateUserFromAccount do
  @moduledoc false

  use Commanded.Event.Handler, name: "Users.Workflows.CreateUserFromAccount"

  alias Plustwo.Domain.Router
  alias Plustwo.Domain.Accounts.Events.AccountRegistered
  alias Plustwo.Domain.Users.Notifications
  alias Plustwo.Domain.Users.Schemas.User
  alias Plustwo.Domain.Users.Commands.CreateUser

  def handle(%AccountRegistered{uuid: account_uuid, is_org: false},
             _metadata) do
    case create_user(%{account_uuid: account_uuid}) do
      {:ok, _user} ->
        :ok

      _ ->
        {:error, "unable to create user"}
    end
  end


  defp create_user(attrs) do
    user_uuid = UUID.uuid4()
    command =
      attrs
      |> CreateUser.new()
      |> CreateUser.assign_uuid(user_uuid)
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for User, user_uuid, version
    else
      reply ->
        reply
    end
  end
end
