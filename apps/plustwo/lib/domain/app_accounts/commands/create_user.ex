defmodule Plustwo.Domain.AppAccounts.Commands.CreateUser do
  @moduledoc false

  defstruct user_uuid: nil, app_account_uuid: nil
  use Plustwo.Domain, :command

  alias Plustwo.Domain.AppAccounts.Commands.CreateUser

  validates :user_uuid, presence: true, uuid: true
  validates :app_account_uuid, presence: true, uuid: true

  @doc "Assigns a unique user identity."
  def assign_user_uuid(%CreateUser{} = user, user_uuid) do
    %CreateUser{user | user_uuid: user_uuid}
  end


  @doc "Assigns app account UUID."
  def assign_app_account_uuid(%CreateUser{} = user, app_account_uuid) do
    %CreateUser{user | app_account_uuid: app_account_uuid}
  end
end
