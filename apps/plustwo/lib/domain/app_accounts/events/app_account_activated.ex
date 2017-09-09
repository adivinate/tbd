defmodule Plustwo.Domain.AppAccounts.Events.AppAccountActivated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_account_uuid]
end
