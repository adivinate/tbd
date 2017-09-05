defmodule Plustwo.Domain.Users.Aggregates.User do
  @moduledoc "A user on Plustwo."

  defstruct uuid: nil,
            account_uuid: nil,
            family_name: nil,
            given_name: nil,
            middle_name: nil,
            birthdate_day: nil,
            birthdate_month: nil,
            birthdate_year: nil
  alias Plustwo.Domain.Users.Aggregates.User
  alias Plustwo.Domain.Users.Events.{UserBirthdateUpdated,
                                     UserCreated,
                                     UserNameUpdated}

  def apply(%User{} = user, %UserBirthdateUpdated{} = updated) do
    %User{user |
          birthdate_day: updated.birthdate_day,
          birthdate_month: updated.birthdate_month,
          birthdate_year: updated.birthdate_year}
  end

  def apply(%User{} = user, %UserCreated{} = created) do
    %User{user | uuid: created.uuid, account_uuid: created.account_uuid}
  end

  def apply(%User{} = user, %UserNameUpdated{} = updated) do
    %User{user |
          family_name: updated.family_name,
          given_name: updated.given_name,
          middle_name: updated.middle_name}
  end
end
