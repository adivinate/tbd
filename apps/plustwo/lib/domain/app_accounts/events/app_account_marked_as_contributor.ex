defmodule Plustwo.Domain.AppAccounts.Events.AppAccountMarkedAsContributor do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :is_contributor]
end
