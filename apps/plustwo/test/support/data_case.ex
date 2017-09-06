defmodule Plustwo.DataCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Plustwo.Infrastructure.Repo.Postgres

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Plustwo.DataCase
    end
  end

  setup tags do
    Plustwo.Storage.reset!()

    :ok
  end
end
