defmodule Plustwo.Domain.AppUsers.Validators.UniqueAppAccountUuid do
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
    case AppUsers.get_app_user_by_app_account_uuid(value) do
      nil ->
        :ok

      _ ->
        {:error, "has already been taken"}
    end
  end
end
