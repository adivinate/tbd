defmodule Plustwo.Domain.AppAccounts.Events.UserMarkedAsContributor do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:user_uuid]
end
