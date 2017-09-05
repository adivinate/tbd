defmodule Plustwo.Domain.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link do
    Supervisor.start_link __MODULE__, nil, name: __MODULE__
  end


  def init(_) do
    children = [
      supervisor(Plustwo.Domain.Accounts.Supervisor, []),
      supervisor(Plustwo.Domain.Users.Supervisor, []),
    ]
    supervise children, strategy: :one_for_one
  end
end
