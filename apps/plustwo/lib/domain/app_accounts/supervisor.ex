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
      worker(AppAccounts.Projectors.AppAccount,
             [],
             id: :app_accounts_app_account_projector),
      worker(AppAccounts.Projectors.Business,
             [],
             id: :app_accounts_business_projector),
      worker(AppAccounts.Projectors.User, [], id: :app_accounts_user_projector),
      worker(AppAccounts.Workflows.CreateBusinessFromAppAccount,
             [],
             id: :create_business_from_app_account),
      worker(AppAccounts.Workflows.CreateUserFromAppAccount,
             [],
             id: :create_user_from_app_account),
      worker(AppAccounts.Workflows.SendPrimaryEmailVerificationCode,
             [],
             id: :send_primary_email_verification_code_workflow),
    ]
    supervise children, strategy: :one_for_one
  end
end
