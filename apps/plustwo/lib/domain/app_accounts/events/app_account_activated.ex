defmodule Plustwo.Domain.AppAccounts.Events.AppAccountActivated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :is_activated]
end
