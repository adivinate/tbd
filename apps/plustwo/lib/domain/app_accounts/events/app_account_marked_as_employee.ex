defmodule Plustwo.Domain.AppAccounts.Events.AppAccountMarkedAsEmployee do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_account_uuid]
end
