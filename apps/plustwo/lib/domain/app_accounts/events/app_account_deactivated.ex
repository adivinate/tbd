defmodule Plustwo.Domain.AppAccounts.Events.AppAccountDeactivated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :is_activated]
end
