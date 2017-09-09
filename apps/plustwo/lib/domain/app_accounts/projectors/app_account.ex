defmodule Plustwo.Domain.AppAccounts.Projectors.AppAccount do
  @moduledoc false

  use Commanded.Projections.Ecto, name: "AppAccounts.Projectors.AppAccount"

  alias Ecto.Multi
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
                                           AppAccountPrimaryEmailVerified,
                                           AppAccountRegistered,
                                           AppAccountSuspended,
                                           AppAccountSuspensionLifted}

  project %AppAccountActivated{app_account_uuid: app_account_uuid}, metadata do
    update_app_account multi, app_account_uuid, metadata, is_activated: true
  end
  project %AppAccountDeactivated{app_account_uuid: app_account_uuid},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_activated: false
  end
  project %AppAccountHandleNameChanged{} = changed, metadata do
    update_app_account multi,
                       changed.app_account_uuid,
                       metadata,
                       handle_name: changed.handle_name
  end
  project %AppAccountMarkedAsContributor{app_account_uuid: app_account_uuid},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_contributor: true
  end
  project %AppAccountMarkedAsEmployee{app_account_uuid: app_account_uuid},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_employee: true
  end
  project %AppAccountMarkedAsNonContributor{app_account_uuid: app_account_uuid},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_contributor: false
  end
  project %AppAccountMarkedAsNonEmployee{app_account_uuid: app_account_uuid},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_employee: false
  end
  project %AppAccountPrimaryEmailUpdated{app_account_uuid: app_account_uuid,
                                         email_address: email_address},
          metadata do
    update_app_account_email multi,
                             app_account_uuid,
                             0,
                             metadata,
                             address: email_address, is_verified: false
  end
  project %AppAccountPrimaryEmailVerified{app_account_uuid: app_account_uuid},
          metadata do
    update_app_account_email multi,
                             app_account_uuid,
                             0,
                             metadata,
                             is_verified: true
  end
  project %AppAccountRegistered{} = registered, %{stream_version: version} do
    multi
    |> Multi.insert(:app_account,
                    %AppAccount{uuid: registered.app_account_uuid,
                                version: version,
                                is_activated: registered.is_activated,
                                is_suspended: registered.is_suspended,
                                is_employee: registered.is_employee,
                                is_contributor: registered.is_contributor,
                                is_org: registered.is_org,
                                handle_name: registered.handle_name})
    |> Multi.insert(:app_account_email,
                    %AppAccountEmail{version: version,
                                     app_account_uuid: registered.app_account_uuid,
                                     address: registered.email,
                                     type: registered.email_type,
                                     is_verified: registered.is_email_verified})
  end
  project %AppAccountSuspended{app_account_uuid: app_account_uuid}, metadata do
    update_app_account multi, app_account_uuid, metadata, is_suspended: true
  end
  project %AppAccountSuspensionLifted{app_account_uuid: app_account_uuid},
          metadata do
    update_app_account multi, app_account_uuid, metadata, is_suspended: false
  end
  def after_update(_event, _metadata, changes) do
    Notifications.publish_changes changes
  end


  defp update_app_account(multi, app_account_uuid, metadata, changes) do
    Multi.update_all multi,
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
    Multi.update_all multi,
                     :app_account_email,
                     AppAccountEmailQuery.by_app_account_uuid(app_account_uuid,
                                                              email_type),
                     [set: changes ++ [version: metadata.stream_version]],
                     returning: true
  end
end
