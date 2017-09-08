defmodule Plustwo.Domain.AppUsers.Projectors.AppUser do
  @moduledoc false

  use Commanded.Projections.Ecto, name: "AppUsers.Projectors.AppUser"

  alias Ecto.Multi
  alias Plustwo.Domain.AppUsers.Notifications
  alias Plustwo.Domain.AppUsers.Schemas.AppUser
  alias Plustwo.Domain.AppUsers.Queries.AppUserQuery
  alias Plustwo.Domain.AppUsers.Events.{AppUserBirthdateUpdated,
                                        AppUserCreated,
                                        AppUserNameUpdated}

  project %AppUserBirthdateUpdated{} = updated, metadata do
    update_app_user multi,
                    updated.app_user_uuid,
                    metadata,
                    birthdate_day: updated.birthdate_day,
                    birthdate_month: updated.birthdate_month,
                    birthdate_year: updated.birthdate_year
  end
  project %AppUserCreated{} = created, %{stream_version: version} do
    Multi.insert multi,
                 :app_user,
                 %AppUser{uuid: created.app_user_uuid,
                          version: version,
                          app_account_uuid: created.app_account_uuid}
  end
  project %AppUserNameUpdated{} = updated, metadata do
    update_app_user multi,
                    updated.app_user_uuid,
                    metadata,
                    given_name: updated.given_name,
                    lgiven_name: String.downcase(updated.given_name),
                    middle_name: updated.middle_name,
                    family_name: updated.family_name,
                    lfamily_name: String.downcase(updated.family_name)
  end
  def after_update(_event, _metadata, changes) do
    Notifications.publish_changes changes
  end


  defp update_app_user(multi, app_user_uuid, metadata, changes) do
    Multi.update_all multi,
                     :app_user,
                     AppUserQuery.by_uuid(app_user_uuid),
                     [set: changes ++ [version: metadata.stream_version]],
                     returning: true
  end
end
