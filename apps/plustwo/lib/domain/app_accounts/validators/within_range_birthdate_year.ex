defmodule Plustwo.Domain.AppAccounts.Validators.WithinRangeBirthdateYear do
  @moduledoc false

  use Vex.Validator

  def validate("", _context) do
    :ok
  end

  def validate(nil, _context) do
    :ok
  end

  def validate(value, _context) do
    end_year = DateTime.utc_now().year
    start_year = end_year - 120
    case value in start_year..end_year do
      true ->
        :ok

      false ->
        {:error, "not within range"}
    end
  end
end
