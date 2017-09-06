defmodule Plustwo.Domain.Router do
  @moduledoc "Dispatch commands to command handlers."

  use Commanded.Commands.Router

  alias Plustwo.Domain.AppAccounts.Aggregates.AppAccount
  alias Plustwo.Domain.AppAccounts.CommandHandlers.AppAccountHandler
  alias Plustwo.Domain.AppAccounts.Commands.{RegisterAppAccount,
                                             UpdateAppAccount}
  alias Plustwo.Domain.AppUsers.Aggregates.AppUser
  alias Plustwo.Domain.AppUsers.CommandHandlers.AppUserHandler
  alias Plustwo.Domain.AppUsers.Commands.{CreateAppUser, UpdateAppUser}

  middleware Plustwo.Infrastructure.Validation.Middlewares.Validate
  dispatch [RegisterAppAccount, UpdateAppAccount],
           to: AppAccountHandler, aggregate: AppAccount, identity: :uuid
  dispatch [CreateAppUser, UpdateAppUser],
           to: AppUserHandler, aggregate: AppUser, identity: :uuid
end
