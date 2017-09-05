defmodule Plustwo.Domain.Accounts.Projectors.Account do
  @moduledoc false

  use Commanded.Projections.Ecto, name: "Accounts.Projectors.Account"

  alias Plustwo.Domain.Accounts.Notifications
  alias Plustwo.Domain.Accounts.Schemas.{Account, AccountEmail}
  alias Plustwo.Domain.Accounts.Queries.{AccountQuery, AccountEmailQuery}
  alias Plustwo.Domain.Accounts.Events.{AccountActivated,
                                        #AccountBillingEmailAdded,
                                        #AccountBillingEmailRemoved,
                                        AccountDeactivated,
                                        AccountHandleNameChanged,
                                        AccountMarkedAsContributor,
                                        AccountMarkedAsEmployee,
                                        AccountMarkedAsNonContributor,
                                        AccountMarkedAsNonEmployee,
                                        AccountPrimaryEmailUpdated,
                                        #AccountPrimaryEmailVerified,
                                        AccountRegistered,
                                        AccountSuspended,
                                        AccountSuspensionLifted}

  project %AccountActivated{uuid: uuid, is_activated: is_activated}, metadata do
    update_account multi, uuid, metadata, is_activated: is_activated
  end
  project %AccountDeactivated{uuid: uuid, is_activated: is_activated},
          metadata do
    update_account multi, uuid, metadata, is_activated: is_activated
  end
  project %AccountHandleNameChanged{} = changed, metadata do
    update_account multi,
                   changed.uuid,
                   metadata,
                   handle_name: changed.handle_name
  end
  project %AccountMarkedAsContributor{uuid: uuid,
                                      is_contributor: is_contributor},
          metadata do
    update_account multi, uuid, metadata, is_contributor: is_contributor
  end
  project %AccountMarkedAsEmployee{uuid: uuid, is_employee: is_employee},
          metadata do
    update_account multi, uuid, metadata, is_employee: is_employee
  end
  project %AccountMarkedAsNonContributor{uuid: uuid,
                                         is_contributor: is_contributor},
          metadata do
    update_account multi, uuid, metadata, is_contributor: is_contributor
  end
  project %AccountMarkedAsNonEmployee{uuid: uuid, is_employee: is_employee},
          metadata do
    update_account multi, uuid, metadata, is_employee: is_employee
  end
  project %AccountPrimaryEmailUpdated{} = updated, metadata do
    update_account_email multi,
                         updated.uuid,
                         0,
                         metadata,
                         address: updated.primary_email,
                         is_verified: updated.is_primary_email_verified
  end
  project %AccountRegistered{} = registered, %{stream_version: version} do
    multi
    |> Ecto.Multi.insert(:account,
                         %Account{uuid: registered.uuid,
                                  version: version,
                                  is_activated: registered.is_activated,
                                  is_suspended: registered.is_suspended,
                                  is_employee: registered.is_employee,
                                  is_contributor: registered.is_contributor,
                                  is_org: registered.is_org,
                                  handle_name: registered.handle_name})
    |> Ecto.Multi.insert(:account_email,
                         %AccountEmail{version: version,
                                       account_uuid: registered.uuid,
                                       address: registered.email,
                                       type: registered.email_type,
                                       is_verified: registered.is_email_verified})
  end
  project %AccountSuspended{uuid: uuid, is_suspended: is_suspended}, metadata do
    update_account multi, uuid, metadata, is_suspended: is_suspended
  end
  project %AccountSuspensionLifted{uuid: uuid, is_suspended: is_suspended},
          metadata do
    update_account multi, uuid, metadata, is_suspended: is_suspended
  end
  def after_update(_event, _metadata, changes) do
    Notifications.publish_changes changes
  end


  defp update_account(multi, uuid, metadata, changes) do
    Ecto.Multi.update_all multi,
                          :account,
                          AccountQuery.by_uuid(uuid),
                          [set: changes ++ [version: metadata.stream_version]],
                          returning: true
  end


  defp update_account_email(multi,
                            account_uuid,
                            email_type,
                            metadata,
                            changes) do
    Ecto.Multi.update_all multi,
                          :account_email,
                          AccountEmailQuery.by_account_uuid(account_uuid,
                                                            email_type),
                          [set: changes ++ [version: metadata.stream_version]],
                          returning: true
  end
end
