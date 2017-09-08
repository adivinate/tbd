defmodule Plustwo.Infrastructure.Validation.Validators.Integer do
  @moduledoc "Check if a variable is integer."

  use Vex.Validator

  alias Vex.Validators.By

  def validate(nil, _options) do
    :ok
  end

  def validate("", _options) do
    :ok
  end

  def validate(value, _options) do
    By.validate value, function: &is_number/1
  end
end
