defmodule Plustwo.Domain.AppAccounts.Events.AppAccountMarkedAsNonEmployee do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :is_employee]
end
