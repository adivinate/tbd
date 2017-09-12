defmodule Plustwo.Domain.AppAccounts.Validators.UniqueAppAccountPrimaryEmail do
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
    case AppAccounts.get_app_account_by_primary_email(value) do
      nil ->
        :ok

      _ ->
        {:error, "has already been taken"}
    end
  end
end
