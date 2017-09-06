defmodule Plustwo.Domain.AppUsers.Validators.AppUserUuidMustExist do
  @moduledoc false

  use Vex.Validator

  alias Plustwo.Domain.AppUsers

  def validate("", _context) do
    :ok
  end

  def validate(nil, _context) do
    :ok
  end

  def validate(value, _context) do
    case AppUsers.get_app_user_by_uuid(value) do
      nil ->
        {:error, "does not exist"}

      _ ->
        :ok
    end
  end
end
