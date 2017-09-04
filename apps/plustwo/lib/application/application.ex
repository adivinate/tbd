defmodule Plustwo.Application do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use Plustwo.Application, :router

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
    end
  end

  def schema do
    quote do
      use Absinthe.Schema.Notation
      use Absinthe.Ecto, repo: Plustwo.Infrastructure.Repo.Postgres
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
