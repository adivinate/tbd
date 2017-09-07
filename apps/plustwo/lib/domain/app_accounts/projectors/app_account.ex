defmodule Plustwo.Domain.AppAccounts.Projectors.AppAccount do
  @moduledoc false

  use Commanded.Projections.Ecto, name: "AppAccounts.Projectors.AppAccount"

  alias Plustwo.Domain.AppAccounts.Notifications
  alias Plustwo.Domain.AppAccounts.Schemas.{AppAccount, AppAccountEmail}
  alias Plustwo.Domain.AppAccounts.Queries.{AppAccountQuery,
                                            AppAccountEmailQuery}
  alias Plustwo.Domain.AppAccounts.Events.{AppAccountActivated,
                                           #AppAccountBillingEmailAdded,
                                           #AppAccountBillingEmailRemoved,
                                           AppAccountDeactivated,
                                           AppAccountHandleNameChanged,
                                           AppAccountMarkedAsContributor,
                                           AppAccountMarkedAsEmployee,
                                           AppAccountMarkedAsNonContributor,
                                           AppAccountMarkedAsNonEmployee,
                                           AppAccountPrimaryEmailUpdated,
                                           #AppAccountPrimaryEmailVerified,
                                           AppAccountRegistered,
                                           AppAccountSuspended,
                                           AppAccountSuspensionLifted}

  project %AppAccountActivated{app_account_uuid: app_account_uuid, is_activated: is_activated},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_activated: is_activated
  end
  project %AppAccountDeactivated{app_account_uuid: app_account_uuid, is_activated: is_activated},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_activated: is_activated
  end
  project %AppAccountHandleNameChanged{} = changed, metadata do
    update_app_account multi,
                       changed.app_account_uuid,
                       metadata,
                       handle_name: changed.handle_name
  end
  project %AppAccountMarkedAsContributor{app_account_uuid: app_account_uuid,
                                         is_contributor: is_contributor},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_contributor: is_contributor
  end
  project %AppAccountMarkedAsEmployee{app_account_uuid: app_account_uuid, is_employee: is_employee},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_employee: is_employee
  end
  project %AppAccountMarkedAsNonContributor{app_account_uuid: app_account_uuid,
                                            is_contributor: is_contributor},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_contributor: is_contributor
  end
  project %AppAccountMarkedAsNonEmployee{app_account_uuid: app_account_uuid, is_employee: is_employee},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_employee: is_employee
  end
  project %AppAccountPrimaryEmailUpdated{} = updated, metadata do
    update_app_account_email multi,
                             updated.app_account_uuid,
                             0,
                             metadata,
                             address: updated.primary_email,
                             is_verified: updated.is_primary_email_verified
  end
  project %AppAccountRegistered{} = registered, %{stream_version: version} do
    multi
    |> Ecto.Multi.insert(:app_account,
                         %AppAccount{uuid: registered.app_account_uuid,
                                     version: version,
                                     is_activated: registered.is_activated,
                                     is_suspended: registered.is_suspended,
                                     is_employee: registered.is_employee,
                                     is_contributor: registered.is_contributor,
                                     is_org: registered.is_org,
                                     handle_name: registered.handle_name})
    |> Ecto.Multi.insert(:app_account_email,
                         %AppAccountEmail{version: version,
                                          app_account_uuid: registered.app_account_uuid,
                                          address: registered.email,
                                          type: registered.email_type,
                                          is_verified: registered.is_email_verified})
  end
  project %AppAccountSuspended{app_account_uuid: app_account_uuid, is_suspended: is_suspended},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_suspended: is_suspended
  end
  project %AppAccountSuspensionLifted{app_account_uuid: app_account_uuid, is_suspended: is_suspended},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_suspended: is_suspended
  end
  def after_update(_event, _metadata, changes) do
    Notifications.publish_changes changes
  end


  defp update_app_account(multi, app_account_uuid, metadata, changes) do
    Ecto.Multi.update_all multi,
                          :app_account,
                          AppAccountQuery.by_uuid(app_account_uuid),
                          [set: changes ++ [version: metadata.stream_version]],
                          returning: true
  end


  defp update_app_account_email(multi,
                                app_account_uuid,
                                email_type,
                                metadata,
                                changes) do
    Ecto.Multi.update_all multi,
                          :app_account_email,
                          AppAccountEmailQuery.by_app_account_uuid(app_account_uuid,
                                                                   email_type),
                          [set: changes ++ [version: metadata.stream_version]],
                          returning: true
  end
end
