defmodule Plustwo.Domain.AppUsers.Commands.CreateAppUser do
  @moduledoc false

  defstruct app_user_uuid: "", app_account_uuid: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppUsers.Commands.CreateAppUser
  alias Plustwo.Domain.AppUsers.Validators.{AppAccountUuidMustExist,
                                            UniqueAppAccountUuid}

  validates :app_user_uuid, presence: true, uuid: true
  validates :app_account_uuid,
            presence: true,
            uuid: true,
            by: &UniqueAppAccountUuid.validate/2,
            by: &AppAccountUuidMustExist.validate/2

  @doc "Assigns a unique app user identity."
  def assign_app_user_uuid(%CreateAppUser{} = app_user, app_user_uuid) do
    %CreateAppUser{app_user | app_user_uuid: app_user_uuid}
  end
end
