defmodule Plustwo.Domain.AppAccounts.Events.AppAccountHandleNameChanged do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:app_account_uuid, :handle_name]
end
