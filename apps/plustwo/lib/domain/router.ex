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
  alias Plustwo.Domain.AppOrgs.Aggregates.AppOrg
  alias Plustwo.Domain.AppOrgs.CommandHandlers.AppOrgHandler
  alias Plustwo.Domain.AppOrgs.Commands.{CreateAppOrg,
                                         UpdateAppOrgMember,
                                         UpdateAppOrg}

  middleware Plustwo.Infrastructure.Validation.Middlewares.Validate
  dispatch [RegisterAppAccount, UpdateAppAccount],
           to: AppAccountHandler,
           aggregate: AppAccount,
           identity: :app_account_uuid
  dispatch [CreateAppUser, UpdateAppUser],
           to: AppUserHandler, aggregate: AppUser, identity: :app_user_uuid
  dispatch [CreateAppOrg, UpdateAppOrgMember, UpdateAppOrg],
           to: AppOrgHandler, aggregate: AppOrg, identity: :app_org_uuid
end
