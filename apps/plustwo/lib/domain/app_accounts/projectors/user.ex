defmodule Plustwo.Domain.AppAccounts.Projectors.User do
  @moduledoc false

  use Commanded.Projections.Ecto, name: "AppAccounts.Projectors.User"

  alias Ecto.Multi
  alias Plustwo.Domain.AppAccounts.Notifications
  alias Plustwo.Domain.AppAccounts.Schemas.User
  alias Plustwo.Domain.AppAccounts.Queries.UserQuery
  alias Plustwo.Domain.AppAccounts.Events.{UserBirthdateUpdated,
                                           UserCreated,
                                           UserMarkedAsContributor,
                                           UserMarkedAsEmployee,
                                           UserMarkedAsNonContributor,
                                           UserMarkedAsNonEmployee,
                                           UserNameUpdated}

  project %UserBirthdateUpdated{user_uuid: user_uuid,
                                birthdate_day: birthdate_day,
                                birthdate_month: birthdate_month,
                                birthdate_year: birthdate_year},
          metadata do
    update_user multi,
                user_uuid,
                metadata,
                birthdate_day: birthdate_day,
                birthdate_month: birthdate_month,
                birthdate_year: birthdate_year
  end
  project %UserCreated{user_uuid: user_uuid,
                       app_account_uuid: app_account_uuid},
          %{stream_version: version} do
    Multi.insert multi,
                 :user,
                 %User{uuid: user_uuid,
                          version: version,
                          app_account_uuid: app_account_uuid}
  end
  project %UserMarkedAsContributor{user_uuid: user_uuid}, metadata do
    update_user multi, user_uuid, metadata, is_contributor: true
  end
  project %UserMarkedAsEmployee{user_uuid: user_uuid}, metadata do
    update_user multi, user_uuid, metadata, is_employee: true
  end
  project %UserMarkedAsNonContributor{user_uuid: user_uuid}, metadata do
    update_user multi, user_uuid, metadata, is_contributor: false
  end
  project %UserMarkedAsNonEmployee{user_uuid: user_uuid}, metadata do
    update_user multi, user_uuid, metadata, is_employee: false
  end
  project %UserNameUpdated{user_uuid: user_uuid,
                           given_name: given_name,
                           middle_name: middle_name,
                           family_name: family_name},
          metadata do
    update_user multi,
                user_uuid,
                metadata,
                given_name: given_name,
                lgiven_name: String.downcase(given_name),
                middle_name: middle_name,
                family_name: family_name,
                lfamily_name: String.downcase(family_name)
  end
  def after_update(_event, _metadata, changes) do
    Notifications.publish_changes changes
  end


  defp update_user(multi, user_uuid, metadata, changes) do
    Multi.update_all multi,
                     :user,
                     UserQuery.by_uuid(user_uuid),
                     [set: changes ++ [version: metadata.stream_version]],
                     returning: true
  end
end
