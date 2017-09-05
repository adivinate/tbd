defmodule Plustwo.Domain.Users.Supervisor do
  @moduledoc false

  use Supervisor

  alias Plustwo.Domain.Users

  def start_link do
    Supervisor.start_link __MODULE__, nil, name: __MODULE__
  end


  def init(_) do
    children = [
      supervisor(Registry, [:duplicate, Plustwo.Domain.Users]),
      # Read model projections
      worker(Users.Projectors.User, [], id: :users_user_projector),
      # Workflows
      worker(Users.Workflows.CreateUserFromAccount,
             [],
             id: :create_user_from_account_workflow),
    ]
    supervise children, strategy: :one_for_one
  end
end
