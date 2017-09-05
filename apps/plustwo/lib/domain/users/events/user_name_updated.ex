defmodule Plustwo.Domain.Users.Events.UserNameUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :given_name, :middle_name, :family_name]
end
