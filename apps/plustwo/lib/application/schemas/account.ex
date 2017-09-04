defmodule Plustwo.Application.Schemas.Account do
  @moduledoc false

  use Plustwo.Application, :schema
  alias Plustwo.Application.Resolvers

  import_types Plustwo.Application.Schemas.Types.Account

  object :account_queries do
    @desc "Retrieves an account"
    field :account, type: :account do
      arg :uuid, non_null(:string)

      resolve &Resolvers.Account.find/3
    end
  end
end
