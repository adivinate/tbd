defmodule Plustwo.Domain.Users.Events.UserCreated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :account_uuid]
end
