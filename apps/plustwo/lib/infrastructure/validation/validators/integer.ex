defmodule Plustwo.Infrastructure.Validation.Validators.Integer do
  @moduledoc "Check if a variable is integer."

  use Vex.Validator

  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok
  def validate(value, _options) do
    Vex.Validators.By.validate(value, [function: &is_number/1])
  end
end
