defmodule Plustwo.Infrastructure.Repo.RedisPool do
  @moduledoc "An interface to interact with a pool of Redis."

  use Supervisor

  @pool_size 20
  @host Application.get_env(:redis, :host)
  @port Application.get_env(:redis, :port)
  def start_link do
    Supervisor.start_link __MODULE__, []
  end


  def init([]) do
    redix_workers = for i <- 0..@pool_size - 1 do
        worker Redix,
               [
                 [host: @host, port: @port],
                 [name: :erlang.binary_to_atom("redix_#{i}", :utf8)],
               ],
               id: {Redix, i}
      end
    supervise redix_workers, strategy: :one_for_one, name: __MODULE__
  end


  @doc """
  This is just a wrapper around Redix's `command`.

  Issues a command on the Redis server.

  This function sends command to the Redis server and returns the response returned by Redis. pid must be the pid of a Redix connection. command must be a list of strings making up the Redis command and its arguments.

  The return value is {:ok, response} if the request is successful and the response is not a Redis error. {:error, reason} is returned in case there’s an error in the request (such as losing the connection to Redis in between the request). If Redis returns an error (such as a type error), a Redix.Error exception is raised; the reason for this is that these errors are semantic errors that most of the times won’t go away by themselves over time and users of Redix should be notified of them as soon as possible. Connection errors, instead, are often temporary errors that will go away when the connection is back.

  If the given command is an empty command ([]), an ArgumentError exception is raised.

  ## Examples

    iex> Redix.command(conn, ["SET", "mykey", "foo"])
    {:ok, "OK"}
    iex> Redix.command(conn, ["GET", "mykey"])
    {:ok, "foo"}

  """
  def command(command) do
    Redix.command :erlang.binary_to_atom("redix_#{random_index()}", :utf8),
                  command
  end


  defp random_index do
    rem System.unique_integer([:positive]), @pool_size
  end
end
