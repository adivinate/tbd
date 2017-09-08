defmodule Plustwo.Infrastructure.Validation.Validators.Boolean do
  @moduledoc "Check if a variable is boolean."

  use Vex.Validator

  alias Vex.Validators.By

  def validate(nil, _options) do
    :ok
  end

  def validate("", _options) do
    :ok
  end

  def validate(value, _options) do
    By.validate value, function: &is_boolean/1
  end
end
