defmodule Plustwo.Domain.Accounts.Validators.UniqueAccountPrimaryEmail do
  @moduledoc false

  use Vex.Validator

  alias Plustwo.Domain.Accounts

  def validate("", _context) do
    :ok
  end

  def validate(nil, _context) do
    :ok
  end

  def validate(value, _context) do
    case Accounts.get_user_account_by_primary_email(value) do
      nil ->
        :ok

      _ ->
        {:error, "has already been taken"}
    end
  end
end
