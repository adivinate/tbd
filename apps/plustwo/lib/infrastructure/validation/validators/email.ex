defmodule Plustwo.Infrastructure.Validation.Validators.Email do
  @moduledoc "Validates an email address format."

  use Vex.Validator

  def validate(nil, _options) do
    :ok
  end

  def validate("", _options) do
    :ok
  end

  def validate(value, _options) do
    case Regex.match?(~r/\S+@\S+\.\S+/, value) do
      true ->
        :ok

      false ->
        {:error, "invalid email address format"}
    end
  end
end
