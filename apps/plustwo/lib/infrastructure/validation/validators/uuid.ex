defmodule Plustwo.Infrastructure.Validation.Validators.Uuid do
  @moduledoc "Check if a variable is UUID."

  use Vex.Validator

  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok
  def validate(value, _options) do
    case UUID.info(value) do
      {:ok, _} -> :ok
      {:error, _} -> {:error, "not a valid uuid"}
    end
  end
end
