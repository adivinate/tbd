defmodule Plustwo.Infrastructure.Validation.Validators.String do
  @moduledoc "Check if a variable is string."

  use Vex.Validator

  alias Vex.Validators.By

  def validate(nil, _options) do
    :ok
  end

  def validate("", _options) do
    :ok
  end

  def validate(value, _options) do
    By.validate value, function: &String.valid?/1
  end
end
