defmodule Plustwo.Domain.Accounts.Supervisor do
  @moduledoc false

  use Supervisor

  alias Plustwo.Domain.Accounts

  def start_link do
    Supervisor.start_link __MODULE__, nil, name: __MODULE__
  end


  def init(_) do
    children = [
      supervisor(Registry, [:duplicate, Plustwo.Domain.Accounts]),
      # Read model projections
      worker(Accounts.Projectors.Account, [], id: :accounts_account_projector),
      # Workflows
      worker(Accounts.Workflows.SendPrimaryEmailVerificationCode,
             [],
             id: :send_primary_email_verification_code_workflow),
    ]
    supervise children, strategy: :one_for_one
  end
end
