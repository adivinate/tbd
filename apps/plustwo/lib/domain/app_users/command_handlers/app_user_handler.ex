defmodule Plustwo.Domain.AppUsers.CommandHandlers.AppUserHandler do
  @moduledoc false

  @behaviour Commanded.Commands.Handler
  alias Plustwo.Domain.AppUsers.Aggregates.AppUser
  alias Plustwo.Domain.AppUsers.Commands.{CreateAppUser, UpdateAppUser}
  alias Plustwo.Domain.AppUsers.Events.{AppUserBirthdateUpdated,
                                        AppUserCreated,
                                        AppUserNameUpdated}

  @doc "Create a user."
  def handle(%AppUser{uuid: nil}, %CreateAppUser{} = create) do
    %AppUserCreated{uuid: create.uuid,
                    app_account_uuid: create.app_account_uuid}
  end

  @doc "Update a user's name, birthdate, etc.."
  def handle(%AppUser{} = app_user, %UpdateAppUser{} = update) do
    fns = [&birthdate_updated/2, &name_updated/2]
    Enum.reduce fns, [], fn change, events -> case change.(app_user, update) do
                    nil ->
                      events

                    {:error, message} ->
                      {:error, message}

                    event ->
                      [event | events]
                  end end
  end


  defp birthdate_updated(%AppUser{},
                         %UpdateAppUser{birthdate_day: nil,
                                        birthdate_month: nil,
                                        birthdate_year: nil}) do
    nil
  end

  defp birthdate_updated(%AppUser{},
                         %UpdateAppUser{birthdate_day: "",
                                        birthdate_month: "",
                                        birthdate_year: ""}) do
    nil
  end

  defp birthdate_updated(%AppUser{birthdate_day: birthdate_day,
                                  birthdate_month: birthdate_month,
                                  birthdate_year: birthdate_year},
                         %UpdateAppUser{birthdate_day: birthdate_day,
                                        birthdate_month: birthdate_month,
                                        birthdate_year: birthdate_year}) do
    nil
  end

  defp birthdate_updated(%AppUser{uuid: uuid},
                         %UpdateAppUser{birthdate_day: birthdate_day,
                                        birthdate_month: birthdate_month,
                                        birthdate_year: birthdate_year}) do
    %AppUserBirthdateUpdated{uuid: uuid,
                             birthdate_day: birthdate_day,
                             birthdate_month: birthdate_month,
                             birthdate_year: birthdate_year}
  end


  defp name_updated(%AppUser{},
                    %UpdateAppUser{given_name: nil,
                                   middle_name: nil,
                                   family_name: nil}) do
    nil
  end

  defp name_updated(%AppUser{},
                    %UpdateAppUser{given_name: "",
                                   middle_name: "",
                                   family_name: ""}) do
    nil
  end

  defp name_updated(%AppUser{given_name: given_name,
                             middle_name: middle_name,
                             family_name: family_name},
                    %UpdateAppUser{given_name: given_name,
                                   middle_name: middle_name,
                                   family_name: family_name}) do
    nil
  end

  defp name_updated(%AppUser{uuid: uuid},
                    %UpdateAppUser{given_name: given_name,
                                   middle_name: middle_name,
                                   family_name: family_name}) do
    %AppUserNameUpdated{uuid: uuid,
                        given_name: given_name,
                        middle_name: middle_name,
                        family_name: family_name}
  end
end
