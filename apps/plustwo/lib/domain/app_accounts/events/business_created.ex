defmodule Plustwo.Domain.AppAccounts.Events.BusinessCreated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:business_uuid, :app_account_uuid]
end
