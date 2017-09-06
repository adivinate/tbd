defmodule Plustwo.Domain.AppAccounts.Supervisor do
  @moduledoc false

  use Supervisor

  alias Plustwo.Domain.AppAccounts

  def start_link do
    Supervisor.start_link __MODULE__, nil, name: __MODULE__
  end


  def init(_) do
    children = [
      supervisor(Registry, [:duplicate, Plustwo.Domain.AppAccounts]),
      # Read model projections
      worker(AppAccounts.Projectors.AppAccount,
             [],
             id: :app_accounts_app_account_projector),
      # Workflows
      worker(AppAccounts.Workflows.SendPrimaryEmailVerificationCode,
             [],
             id: :send_primary_email_verification_code_workflow),
    ]
    supervise children, strategy: :one_for_one
  end
end
