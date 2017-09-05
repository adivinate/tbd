defmodule Plustwo.Domain.Users.Commands.UpdateUser do
  @moduledoc false

  defstruct user_uuid: "",
            given_name: "",
            middle_name: "",
            family_name: "",
            birthdate_day: "",
            birthdate_month: "",
            birthdate_year: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.Users.Commands.UpdateUser
  alias Plustwo.Domain.Users.Validators.{UserUuidMustExist,
                                         WithinRangeBirthdateDay,
                                         WithinRangeBirthdateYear}

  validates :user_uuid,
            presence: true, uuid: true, by: &UserUuidMustExist.validate/2
  validates :given_name, string: true
  validates :middle_name, string: true
  validates :family_name, string: true
  validates :birthdate_year,
            integer: true,
            by: [
              function: &WithinRangeBirthdateYear.validate/2,
              allow_nil: true,
              allow_blank: true,
            ]
  validates :birthdate_month,
            integer: true,
            inclusion: [in: 1..12, allow_nil: true, allow_blank: true]
  validates :birthdate_day,
            integer: true,
            by: [
              function: &WithinRangeBirthdateDay.validate/2,
              allow_nil: true,
              allow_blank: true,
            ]

  @doc "Assign user UUID."
  def assign_user_uuid(%UpdateUser{} = user, user_uuid) do
    %UpdateUser{user | user_uuid: user_uuid}
  end
end
