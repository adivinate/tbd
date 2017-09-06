defmodule Plustwo.Domain.AppAccounts.Events.AppAccountPrimaryEmailUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :primary_email, :is_primary_email_verified]
end
