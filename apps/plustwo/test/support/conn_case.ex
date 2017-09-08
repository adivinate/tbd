defmodule Plustwo.Application.ConnCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  alias Plustwo.Storage
  alias Phoenix.ConnTest

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
    Storage.reset!()
    {:ok, [conn: ConnTest.build_conn()]}
  end
end
