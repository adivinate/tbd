defmodule Plustwo.Domain.AppAccounts.Events.AppAccountMarkedAsNonContributor do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :is_contributor]
end
