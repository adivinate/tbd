defmodule Plustwo.Application.Schemas.AppAccount do
  @moduledoc false

  use Plustwo.Application, :schema

  alias Plustwo.Application.Resolvers

  import_types Plustwo.Application.Schemas.Types.AppAccount
  object :app_account_queries do
    @desc "Retrieves an app account"
    field :app_account, type: :app_account do
      arg :uuid, non_null(:string)
      resolve &Resolvers.AppAccount.find/3
    end
  end
end
