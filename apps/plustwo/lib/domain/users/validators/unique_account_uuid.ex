defmodule Plustwo.Domain.Users.Validators.UniqueAccountUuid do
  @moduledoc false

  use Vex.Validator

  alias Plustwo.Domain.Users

  def validate("", _context) do
    :ok
  end

  def validate(nil, _context) do
    :ok
  end

  def validate(value, _context) do
    case Users.get_user_by_account_uuid(value) do
      nil ->
        :ok

      _ ->
        {:error, "has already been taken"}
    end
  end
end
