defmodule Plustwo.Domain.Users.Commands.CreateUser do
  @moduledoc false

  defstruct uuid: "", account_uuid: ""
  use Plustwo.Domain, :command

  alias Plustwo.Domain.Users.Commands.CreateUser
  alias Plustwo.Domain.Users.Validators.UniqueAccountUuid

  validates :uuid, presence: true, uuid: true
  # dont' need check if account_uuid exists or not
  # because we're using this command only in workflow.
  validates :account_uuid,
            presence: true, uuid: true, by: &UniqueAccountUuid.validate/2

  @doc "Assign a unique identity to user."
  def assign_uuid(%CreateUser{} = user, uuid) do
    %CreateUser{user | uuid: uuid}
  end
end
