defmodule Plustwo.Domain.AppAccounts.Events.UserNameUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:user_uuid, :given_name, :middle_name, :family_name]
end
