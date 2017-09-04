defmodule Plustwo.Application.Schema do
  @moduledoc false

  use Absinthe.Schema

  import_types Plustwo.Application.Schemas.Account

  query do
    import_fields :account_queries
  end
end
