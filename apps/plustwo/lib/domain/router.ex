defmodule Plustwo.Domain.Router do
  @moduledoc "Dispatch commands to command handlers."

  use Commanded.Commands.Router

  alias Plustwo.Domain.AppAccounts.Aggregates.{AppAccount, Business, User}
  alias Plustwo.Domain.AppAccounts.CommandHandlers.{AppAccountHandler,
                                                    BusinessHandler,
                                                    UserHandler}
  alias Plustwo.Domain.AppAccounts.Commands.{CreateBusiness,
                                             CreateUser,
                                             RegisterAppAccount,
                                             UpdateAppAccount,
                                             UpdateBusiness,
                                             UpdateUser}

  middleware Plustwo.Infrastructure.Validation.Middlewares.Validate
  dispatch [RegisterAppAccount, UpdateAppAccount],
           to: AppAccountHandler,
           aggregate: AppAccount,
           identity: :app_account_uuid
  dispatch [CreateUser, UpdateUser],
           to: UserHandler, aggregate: User, identity: :user_uuid
  dispatch [CreateBusiness, UpdateBusiness],
           to: BusinessHandler, aggregate: Business, identity: :business_uuid
end
