defmodule Plustwo.Domain.Accounts.Validators.AccountUuidMustExist do
  @moduledoc false

  use Vex.Validator
  alias Plustwo.Domain.Accounts

  def validate(nil, _context), do: {:error, "is required"}
  def validate("", _context), do: {:error, "is required"}
  def validate(value, _context) do
    case Accounts.get_account_by_uuid(value) do
      nil -> {:error, "does not exist"}
      _ -> :ok
    end
  end
end