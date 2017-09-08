defmodule Plustwo.Application.ConnCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      import Plustwo.Application.Router.Helpers

      # The default endpoint for testing
      @endpoint Plustwo.Application.Endpoint
    end
  end
  setup _tags do
    Plustwo.Storage.reset!()
    {:ok, [conn: Phoenix.ConnTest.build_conn()]}
  end
end
