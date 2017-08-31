defmodule Plustwo.Domain.Application do
  @moduledoc """
  The Plustwo Domain Application Service.

  The plustwo_domain system business domain lives in this application.

  Exposes API to clients such as the `Plustwo.Graphql` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Plustwo.Domain.Repo, []),
    ], strategy: :one_for_one, name: Plustwo.Domain.Supervisor)
  end
end
