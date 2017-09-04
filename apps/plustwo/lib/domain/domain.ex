defmodule Plustwo.Domain do
  @moduledoc """
  A module that keeps using definitions for schema and so on.

  This can be used in your application as:

      use Plustwo.Domain, :schema

  Do NOT define functions inside the quoted expressions
  below.
  """

  def schema do
    quote do
      use Ecto.Schema
      use Calecto.Schema, usec: true
    end
  end

  def query do
    quote do
      import Ecto.Query
    end
  end

  def command do
    quote do
      import Ecto.Changeset
      use ExConstructor
      use Vex.Struct
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
