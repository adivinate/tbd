defmodule Plustwo.Domain.Users.Commands.CreateUser do
  @moduledoc false

  defstruct uuid: "", account_uuid: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.Users.Commands.CreateUser
  alias Plustwo.Domain.Users.Validators.{AccountUuidMustExist,
                                         UniqueAccountUuid}

  validates :uuid, presence: true, uuid: true
  validates :account_uuid,
            presence: true,
            uuid: true,
            by: &UniqueAccountUuid.validate/2,
            by: &AccountUuidMustExist.validate/2

  @doc "Assign a unique identity to user."
  def assign_uuid(%CreateUser{} = user, uuid) do
    %CreateUser{user | uuid: uuid}
  end
end
