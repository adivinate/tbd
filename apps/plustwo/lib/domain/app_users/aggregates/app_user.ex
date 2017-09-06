defmodule Plustwo.Domain.AppUsers.Aggregates.AppUser do
  @moduledoc "A user on Plustwo."

  defstruct uuid: nil,
            app_account_uuid: nil,
            family_name: nil,
            given_name: nil,
            middle_name: nil,
            birthdate_day: nil,
            birthdate_month: nil,
            birthdate_year: nil
  alias Plustwo.Domain.AppUsers.Aggregates.AppUser
  alias Plustwo.Domain.AppUsers.Events.{AppUserBirthdateUpdated,
                                        AppUserCreated,
                                        AppUserNameUpdated}

  def apply(%AppUser{} = app_user, %AppUserBirthdateUpdated{} = updated) do
    %AppUser{app_user |
             birthdate_day: updated.birthdate_day,
             birthdate_month: updated.birthdate_month,
             birthdate_year: updated.birthdate_year}
  end

  def apply(%AppUser{} = app_user, %AppUserCreated{} = created) do
    %AppUser{app_user | uuid: created.uuid, app_account_uuid: created.app_account_uuid}
  end

  def apply(%AppUser{} = app_user, %AppUserNameUpdated{} = updated) do
    %AppUser{app_user |
             family_name: updated.family_name,
             given_name: updated.given_name,
             middle_name: updated.middle_name}
  end
end
