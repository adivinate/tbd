defmodule Plustwo.Infrastructure.Repo.Postgres do
  @moduledoc """
  An interface to interact with Postgres database.
  """

  use Ecto.Repo, otp_app: :plustwo

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
