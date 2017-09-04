defmodule Plustwo.Infrastructure.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    children = [
      # Start the Ecto postgres repository
      supervisor(Plustwo.Infrastructure.Repo.Postgres, []),

      # Start Redis pool
      # supervisor(Plustwo.Infrastructure.Repo.RedisPool, []),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
