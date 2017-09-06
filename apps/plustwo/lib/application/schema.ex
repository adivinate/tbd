defmodule Plustwo.Application.Schema do
  @moduledoc false

  use Absinthe.Schema

  import_types Plustwo.Application.Schemas.AppAccount
  query do
    import_fields :app_account_queries
  end
end
