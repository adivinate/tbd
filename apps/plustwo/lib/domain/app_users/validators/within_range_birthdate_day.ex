defmodule Plustwo.Domain.AppUsers.Validators.WithinRangeBirthdateDay do
  @moduledoc false

  use Vex.Validator

  def validate(nil, _context) do
    :ok
  end

  def validate("", _context) do
    :ok
  end

  def validate(_value, %{birthdate_month: nil}) do
    {:error, "birthdate month is required"}
  end

  def validate(_value, %{birthdate_month: ""}) do
    {:error, "birthdate month is required"}
  end


  @months_with_31_days [1, 3, 5, 7, 8, 10, 12]
  @months_with_30_days [4, 6, 9, 11]
  @months_with_29_days [2]
  def validate(value, %{birthdate_month: birthdate_month})
      when birthdate_month in @months_with_31_days do
    case value > 0 and value <= 31 do
      true ->
        :ok

      false ->
        {:error, "not within range"}
    end
  end

  def validate(value, %{birthdate_month: birthdate_month})
      when birthdate_month in @months_with_30_days do
    case value > 0 and value <= 30 do
      true ->
        :ok

      false ->
        {:error, "not within range"}
    end
  end

  def validate(value, %{birthdate_month: birthdate_month})
      when birthdate_month in @months_with_29_days do
    case value > 0 and value <= 29 do
      true ->
        :ok

      false ->
        {:error, "not within range"}
    end
  end

  def validate(_value, _context) do
    {:error, "invalid birthdate month"}
  end
end
