defmodule Plustwo.Domain.Users.Validators.UserUuidMustExist do
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
    case Users.get_user_by_uuid(value) do
      nil ->
        {:error, "does not exist"}

      _ ->
        :ok
    end
  end
end
