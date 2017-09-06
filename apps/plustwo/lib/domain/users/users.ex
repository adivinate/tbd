defmodule Plustwo.Domain.Users do
  @moduledoc false

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Router
  alias Plustwo.Domain.Users.Notifications
  alias Plustwo.Domain.Users.Queries.UserQuery
  alias Plustwo.Domain.Users.Schemas.User
  alias Plustwo.Domain.Users.Commands.UpdateUser

  ##########
  # Mutations
  ##########
  @doc "Updates a user"
  def update_user(%User{uuid: user_uuid}, attrs) do
    command =
      attrs
      |> UpdateUser.new()
      |> UpdateUser.assign_uuid(user_uuid)
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for User, user_uuid, version
    else
      reply ->
        reply
    end
  end


  ##########
  # Queries
  ##########
  @doc "Retrieves a user by UUID, or return `nil` if not found."
  def get_user_by_uuid(user_uuid) do
    user_uuid
    |> UserQuery.by_uuid()
    |> Postgres.one()
  end

  @doc "Retrieves a user by its account UUID, or return `nil` if not found."
  def get_user_by_account_uuid(account_uuid) do
    account_uuid
    |> UserQuery.by_account_uuid()
    |> Postgres.one()
  end
end
