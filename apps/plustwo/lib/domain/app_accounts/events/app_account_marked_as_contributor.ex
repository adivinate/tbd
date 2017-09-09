defmodule Plustwo.Domain.AppAccounts.Events.AppAccountMarkedAsContributor do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_account_uuid]
end
