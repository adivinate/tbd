defmodule Plustwo.Domain.AppUsers.Supervisor do
  @moduledoc false

  use Supervisor

  alias Plustwo.Domain.AppUsers

  def start_link do
    Supervisor.start_link __MODULE__, nil, name: __MODULE__
  end


  def init(_) do
    children = [
      supervisor(Registry, [:duplicate, Plustwo.Domain.AppUsers]),
      # Read model projections
      worker(AppUsers.Projectors.AppUser,
             [],
             id: :app_users_app_user_projector),
      # Workflows
      worker(AppUsers.Workflows.CreateAppUserFromAppAccount,
             [],
             id: :create_app_user_from_app_account_workflow),
    ]
    supervise children, strategy: :one_for_one
  end
end
