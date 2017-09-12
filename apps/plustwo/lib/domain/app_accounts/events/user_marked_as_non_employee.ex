defmodule Plustwo.Domain.AppAccounts.Events.UserMarkedAsNonEmployee do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:user_uuid]
end
