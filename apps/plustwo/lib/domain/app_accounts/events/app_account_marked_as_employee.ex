defmodule Plustwo.Domain.AppAccounts.Events.AppAccountMarkedAsEmployee do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :is_employee]
end
