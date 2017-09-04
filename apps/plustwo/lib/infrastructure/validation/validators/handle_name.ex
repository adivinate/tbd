defmodule Plustwo.Infrastructure.Validation.Validators.HandleName do
  @moduledoc "Validates a handle name format."

  use Vex.Validator

  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok
  def validate(value, _options) do
    case Regex.match?(~r/^[a-z0-9_]+$/, value) do
      true -> :ok
      false -> {:error, "must contain only lowercase letters, numbers and underscores"}
    end
  end
end
