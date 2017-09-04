defmodule Plustwo do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Start Infrastructure
      supervisor(Plustwo.Infrastructure.Supervisor, []),
      # Start Domain
      supervisor(Plustwo.Domain.Supervisor, []),
      # Start the Application endpoint
      supervisor(Plustwo.Application.Endpoint, []),
    ]
    opts = [strategy: :one_for_one, name: Plustwo.Supervisor]
    Supervisor.start_link children, opts
  end


  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Plustwo.Application.Endpoint.config_change changed, removed
    :ok
  end
end
