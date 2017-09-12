defmodule Plustwo.Domain.AppAccounts.Events.UserMarkedAsNonContributor do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:user_uuid]
end
