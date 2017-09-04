defmodule Plustwo.Infrastructure.Validation.Validators.PhoneNumber do
  @moduledoc "Validates a phone number E.164 format."

  use Vex.Validator

  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok
  def validate(value, _options) do
    case Regex.match?(~r/^[+][0-9]+$/, value) do
      true -> :ok
      false -> {:error, "incorrect E.164 phone number format"}
    end
  end
end
