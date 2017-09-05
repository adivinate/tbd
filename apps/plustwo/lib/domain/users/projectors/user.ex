defmodule Plustwo.Domain.Users.Projectors.User do
  @moduledoc false

  use Commanded.Projections.Ecto, name: "Users.Projectors.User"

  alias Plustwo.Domain.Users.Notifications
  alias Plustwo.Domain.Users.Schemas.User
  alias Plustwo.Domain.Users.Queries.UserQuery
  alias Plustwo.Domain.Users.Events.{UserBirthdateUpdated,
                                     UserCreated,
                                     UserNameUpdated}

  project %UserBirthdateUpdated{} = updated, metadata do
    update_user multi,
                    updated.uuid,
                    metadata,
                    birthdate_day: updated.birthdate_day,
                    birthdate_month: updated.birthdate_month,
                    birthdate_year: updated.birthdate_year
  end
  project %UserCreated{} = created, %{stream_version: version} do
    Ecto.Multi.insert multi,
                      :user,
                      %User{uuid: created.uuid,
                               version: version,
                               account_uuid: created.account_uuid}
  end
  project %UserNameUpdated{} = updated, metadata do
    update_user multi,
                    updated.uuid,
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


  defp update_user(multi, uuid, metadata, changes) do
    Ecto.Multi.update_all multi,
                          :user,
                          UserQuery.by_uuid(uuid),
                          [set: changes ++ [version: metadata.stream_version]],
                          returning: true
  end
end
