defmodule Plustwo.Domain.AppAccounts.Events.BusinessInfoUpdated do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [:business_uuid, :legal_name, :description, :address]
end
