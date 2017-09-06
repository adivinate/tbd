defmodule Plustwo.Domain.AppAccounts.Events.AppAccountSuspensionLifted do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :is_suspended]
end
