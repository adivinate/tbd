defmodule Plustwo.Infrastructure.Components.Crypto do
  @moduledoc "A set functions to hash and encrypt sensitive information."

  alias Comeonin.Bcrypt

  @doc "Hash a value."
  def hash(value, :bcrypt) do
    Bcrypt.hashpwsalt(value)
  end
  def hash(value, _hash_function) do
    value
  end

  @doc "Verify a hash."
  def verify(value, hash, :bcrypt) do
    Bcrypt.checkpw(value, hash)
  end
  def verify(value, _hash, _hash_function) do
    value
  end

  @doc "Compare a password with its hash."
  def validate_user_login_password(
    %{user_login_hashed_password: user_login_hashed_password},
    password,
    :bcrypt)
  do
    Bcrypt.checkpw(password, user_login_hashed_password)
  end
  def validate_user_login_password(_user, _password, _hash_function) do
    Bcrypt.dummy_checkpw()
    {:error, :incorrect_user_or_password}
  end
end
