defmodule Plustwo.Domain.Router do
  @moduledoc "Dispatch commands to command handlers."

  use Commanded.Commands.Router

  alias Plustwo.Domain.Accounts.Aggregates.Account
  alias Plustwo.Domain.Accounts.CommandHandlers.AccountHandler
  alias Plustwo.Domain.Accounts.Commands.{RegisterAccount, UpdateAccount}
  alias Plustwo.Domain.Users.Aggregates.User
  alias Plustwo.Domain.Users.CommandHandlers.UserHandler
  alias Plustwo.Domain.Users.Commands.{CreateUser, UpdateUser}

  middleware Plustwo.Infrastructure.Validation.Middlewares.Validate
  dispatch [RegisterAccount],
           to: AccountHandler, aggregate: Account, identity: :uuid
  dispatch [UpdateAccount],
           to: AccountHandler, aggregate: Account, identity: :account_uuid
  dispatch [CreateUser], to: UserHandler, aggregate: User, identity: :uuid
  dispatch [UpdateUser], to: UserHandler, aggregate: User, identity: :user_uuid
end
