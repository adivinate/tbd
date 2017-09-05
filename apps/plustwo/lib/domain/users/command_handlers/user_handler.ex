defmodule Plustwo.Domain.Users.CommandHandlers.UserHandler do
  @moduledoc false

  @behaviour Commanded.Commands.Handler
  alias Plustwo.Domain.Users.Aggregates.User
  alias Plustwo.Domain.Users.Commands.{CreateUser, UpdateUser}
  alias Plustwo.Domain.Users.Events.{UserBirthdateUpdated,
                                     UserCreated,
                                     UserNameUpdated}

  ##########
  # Handlers
  ##########
  @doc "Create a user."
  def handle(%User{uuid: nil}, %CreateUser{} = create) do
    %UserCreated{uuid: create.uuid, account_uuid: create.account_uuid}
  end

  @doc "Update a user's name, birthdate, etc.."
  def handle(%User{} = user, %UpdateUser{} = update) do
    fns = [&user_birthdate_updated/2, &user_name_updated/2]
    Enum.reduce fns, [], fn change, events -> case change.(user, update) do
                    nil ->
                      events

                    {:error, message} ->
                      {:error, message}

                    event ->
                      [event | events]
                  end end
  end


  defp user_birthdate_updated(%User{},
                              %UpdateUser{birthdate_day: nil,
                                          birthdate_month: nil,
                                          birthdate_year: nil}) do
    nil
  end

  defp user_birthdate_updated(%User{},
                              %UpdateUser{birthdate_day: "",
                                          birthdate_month: "",
                                          birthdate_year: ""}) do
    nil
  end

  defp user_birthdate_updated(%User{birthdate_day: birthdate_day,
                                    birthdate_month: birthdate_month,
                                    birthdate_year: birthdate_year},
                              %UpdateUser{birthdate_day: birthdate_day,
                                          birthdate_month: birthdate_month,
                                          birthdate_year: birthdate_year}) do
    nil
  end

  defp user_birthdate_updated(%User{uuid: uuid},
                              %UpdateUser{birthdate_day: birthdate_day,
                                          birthdate_month: birthdate_month,
                                          birthdate_year: birthdate_year}) do
    %UserBirthdateUpdated{uuid: uuid,
                          birthdate_day: birthdate_day,
                          birthdate_month: birthdate_month,
                          birthdate_year: birthdate_year}
  end


  defp user_name_updated(%User{},
                         %UpdateUser{given_name: nil,
                                     middle_name: nil,
                                     family_name: nil}) do
    nil
  end

  defp user_name_updated(%User{},
                         %UpdateUser{given_name: "",
                                     middle_name: "",
                                     family_name: ""}) do
    nil
  end

  defp user_name_updated(%User{given_name: given_name,
                               middle_name: middle_name,
                               family_name: family_name},
                         %UpdateUser{given_name: given_name,
                                     middle_name: middle_name,
                                     family_name: family_name}) do
    nil
  end

  defp user_name_updated(%User{uuid: uuid},
                         %UpdateUser{given_name: given_name,
                                     middle_name: middle_name,
                                     family_name: family_name}) do
    %UserNameUpdated{uuid: uuid,
                     given_name: given_name,
                     middle_name: middle_name,
                     family_name: family_name}
  end
end
