defmodule Plustwo.Domain.Accounts.Validators.UniqueAccountHandleName do
  @moduledoc false

  use Vex.Validator
  alias Plustwo.Domain.Accounts

  def validate(nil, _context), do: {:error, "is required"}
  def validate("", _context), do: {:error, "is required"}
  def validate(value, _context) do
    case Accounts.get_account_by_handle_name(value) do
      nil -> :ok
      _ -> {:error, "has already been taken"}
    end
  end
end
