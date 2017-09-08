defmodule Plustwo.Domain.AppOrgs.Supervisor do
  @moduledoc false

  use Supervisor

  alias Plustwo.Domain.AppOrgs

  def start_link do
    Supervisor.start_link __MODULE__, nil, name: __MODULE__
  end


  def init(_) do
    children = [
      supervisor(Registry, [:duplicate, Plustwo.Domain.AppOrgs]),
      # Read model projections
      worker(AppOrgs.Projectors.AppOrg, [], id: :app_orgs_app_org_projector),
      # Workflows
      worker(AppOrgs.Workflows.CreateAppOrgFromAppAccount,
             [],
             id: :create_app_org_from_app_account_workflow),
    ]
    supervise children, strategy: :one_for_one
  end
end
