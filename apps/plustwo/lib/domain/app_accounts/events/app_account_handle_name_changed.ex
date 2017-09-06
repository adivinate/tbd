defmodule Plustwo.Domain.AppAccounts.Events.AppAccountHandleNameChanged do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:uuid, :handle_name]
end
