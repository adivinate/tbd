defmodule Plustwo.Domain.AppUsers.Commands.UpdateAppUser do
  @moduledoc false

  defstruct uuid: "",
            given_name: "",
            middle_name: "",
            family_name: "",
            birthdate_day: "",
            birthdate_month: "",
            birthdate_year: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppUsers.Commands.UpdateAppUser
  alias Plustwo.Domain.AppUsers.Validators.{AppUserUuidMustExist,
                                            WithinRangeBirthdateDay,
                                            WithinRangeBirthdateYear}

  validates :uuid,
            presence: true,
            uuid: true,
            by: [
              function: &AppUserUuidMustExist.validate/2,
              allow_nil: false,
              allow_blank: false,
            ]
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

  @doc "Assign app user UUID."
  def assign_uuid(%UpdateAppUser{} = app_user, uuid) do
    %UpdateAppUser{app_user | uuid: uuid}
  end
end
