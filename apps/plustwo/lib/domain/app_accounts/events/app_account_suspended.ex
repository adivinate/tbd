defmodule Plustwo.Domain.AppAccounts.Events.AppAccountSuspended do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :is_suspended]
end
