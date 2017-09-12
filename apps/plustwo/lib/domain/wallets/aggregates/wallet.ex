defmodule Plustwo.Domain.Wallets.Aggregates.Wallet do
  @moduledoc "A payment account that can receive and make payments on Plustwo."

  defstruct wallet_uuid: nil,
            holder_app_account_uuid: nil,
            balance: nil,
            rate: nil
end
