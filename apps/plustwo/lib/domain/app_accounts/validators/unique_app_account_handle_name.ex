defmodule Plustwo.Domain.AppAccounts.Validators.UniqueAppAccountHandleName do
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
    case AppAccounts.get_app_account_by_handle_name(value) do
      nil ->
        :ok

      _ ->
        {:error, "has already been taken"}
    end
  end
end
