defmodule Plustwo.Infrastructure.Validation.Validators.Boolean do
  @moduledoc "Check if a variable is boolean."

  use Vex.Validator

  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok
  def validate(value, _options) do
    Vex.Validators.By.validate(value, [function: &is_boolean/1])
  end
end
