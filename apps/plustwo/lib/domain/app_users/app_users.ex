defmodule Plustwo.Domain.AppUsers do
  @moduledoc false

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Router
  alias Plustwo.Domain.AppUsers.Notifications
  alias Plustwo.Domain.AppUsers.Queries.AppUserQuery
  alias Plustwo.Domain.AppUsers.Schemas.AppUser
  alias Plustwo.Domain.AppUsers.Commands.UpdateAppUser

  @doc "Updates an app user"
  def update_app_user(%AppUser{uuid: app_user_uuid}, attrs) do
    command =
      attrs
      |> UpdateAppUser.new()
      |> UpdateAppUser.assign_uuid(app_user_uuid)
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for AppUser, app_user_uuid, version
    else
      reply ->
        reply
    end
  end


  @doc "Retrieves an app user by UUID, or return `nil` if not found."
  def get_app_user_by_uuid(app_user_uuid) do
    app_user_uuid
    |> AppUserQuery.by_uuid()
    |> Postgres.one()
  end


  @doc "Retrieves a user by its account UUID, or return `nil` if not found."
  def get_app_user_by_app_account_uuid(app_account_uuid) do
    app_account_uuid
    |> AppUserQuery.by_app_account_uuid()
    |> Postgres.one()
  end
end
