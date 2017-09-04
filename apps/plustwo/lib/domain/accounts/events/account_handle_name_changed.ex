defmodule Plustwo.Domain.Accounts.Events.AccountHandleNameChanged do
  @moduledoc false

  @derive [Poison.Encoder]

  defstruct [
    :uuid,
    :handle_name,
  ]
end
