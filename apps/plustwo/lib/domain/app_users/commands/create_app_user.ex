defmodule Plustwo.Domain.AppUsers.Commands.CreateAppUser do
  @moduledoc false

  defstruct uuid: "", app_account_uuid: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppUsers.Commands.CreateAppUser
  alias Plustwo.Domain.AppUsers.Validators.{AppAccountUuidMustExist,
                                            UniqueAppAccountUuid}

  validates :uuid, presence: true, uuid: true
  validates :app_account_uuid,
            presence: true,
            uuid: true,
            by: &UniqueAppAccountUuid.validate/2,
            by: &AppAccountUuidMustExist.validate/2

  @doc "Assigns a unique identity to app user."
  def assign_uuid(%CreateAppUser{} = app_user, uuid) do
    %CreateAppUser{app_user | uuid: uuid}
  end
end
