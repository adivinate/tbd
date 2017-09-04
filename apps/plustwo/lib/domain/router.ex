defmodule Plustwo.Domain.Router do
  @moduledoc "Dispatch commands to command handlers."

  use Commanded.Commands.Router

  alias Plustwo.Domain.Accounts.Aggregates.Account
  alias Plustwo.Domain.Accounts.CommandHandlers.AccountHandler
  alias Plustwo.Domain.Accounts.Commands.{
    RegisterAccount,
    UpdateAccount,
  }

  middleware Plustwo.Infrastructure.Validation.Middlewares.Validate

  dispatch [RegisterAccount], to: AccountHandler, aggregate: Account, identity: :uuid
  dispatch [UpdateAccount], to: AccountHandler, aggregate: Account, identity: :account_uuid
end
