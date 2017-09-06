defmodule Plustwo.Domain.AppAccounts.Events.AppAccountPrimaryEmailVerified do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :is_primary_email_verified]
end
