defmodule Plustwo.Domain.AppUsers.Validators.AppAccountUuidMustExist do
  @moduledoc false

  use Vex.Validator

  alias Plustwo.Domain.AppAccounts

  def validate("", _context) do
    :ok
  end

  def validate(nil, _context) do
    :ok
  end

  def validate(value, _context) do
    case AppAccounts.get_app_account_by_uuid(value) do
      nil ->
        {:error, "does not exist"}

      _ ->
        :ok
    end
  end
end
