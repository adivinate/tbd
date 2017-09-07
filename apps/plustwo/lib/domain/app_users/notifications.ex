defmodule Plustwo.Domain.AppUsers.Notifications do
  @moduledoc false

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.AppUsers.Schemas.AppUser
  alias Plustwo.Domain.AppUsers.Queries.AppUserQuery

  @doc "Waits until the given read model is updated to the given version."
  def wait_for(AppUser, app_user_uuid, version) do
    case Postgres.one(AppUserQuery.by_uuid(app_user_uuid, version)) do
      nil ->
        subscribe_and_wait AppUser, app_user_uuid, version

      projection ->
        {:ok, projection}
    end
  end


  @doc "Publishes updated user read model to interested subscribers."
  def publish_changes(%{app_user: %AppUser{} = app_user}) do
    publish app_user
  end


  def publish_changes(%{app_user: {_, app_users}}) when is_list(app_users) do
    Enum.each app_users, &publish/1
  end


  defp publish(%AppUser{uuid: app_user_uuid, version: version} = app_user) do
    Registry.dispatch Plustwo.Domain.AppUsers,
                      {AppUser, app_user_uuid, version},
                      fn entries ->
                        for {pid, _} <- entries do
                          send pid, {AppUser, app_user}
                        end
                      end
  end


  defp subscribe_and_wait(AppUser, app_user_uuid, version) do
    Registry.register Plustwo.Domain.AppUsers,
                      {AppUser, app_user_uuid, version},
                      []
    receive do
      {AppUser, projection} ->
        {:ok, projection}
    after
      5000 ->
        {:error, :timeout}
    end
  end
end
