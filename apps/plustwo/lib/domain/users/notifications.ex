defmodule Plustwo.Domain.Users.Notifications do
  @moduledoc false

  alias Plustwo.Infrastructure.Repo.Postgres
  alias Plustwo.Domain.Users.Schemas.User
  alias Plustwo.Domain.Users.Queries.UserQuery

  @doc "Waits until the given read model is updated to the given version."
  def wait_for(User, uuid, version) do
    case Postgres.one(UserQuery.by_uuid(uuid, version)) do
      nil ->
        subscribe_and_wait User, uuid, version

      projection ->
        {:ok, projection}
    end
  end


  @doc "Publishes updated user read model to interested subscribers."
  def publish_changes(%{user: %User{} = user}) do
    publish user
  end


  def publish_changes(%{user: {_, users}}) when is_list(users) do
    Enum.each users, &publish/1
  end


  ##########
  # Private Helpers
  ##########
  defp publish(%User{uuid: uuid, version: version} = user) do
    Registry.dispatch Plustwo.Domain.Users,
                      {User, uuid, version},
                      fn entries ->
                        for {pid, _} <- entries do
                          send pid, {User, user}
                        end
                      end
  end


  defp subscribe_and_wait(User, uuid, version) do
    Registry.register Plustwo.Domain.Users, {User, uuid, version}, []
    receive do
      {User, projection} ->
        {:ok, projection}
    after
      5000 ->
        {:error, :timeout}
    end
  end
end
