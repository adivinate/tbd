defmodule Plustwo.Infrastructure.Validation.Validators.Date do
  @moduledoc "Check if a variable is date."

  use Vex.Validator

  def validate(nil, _options) do
    :ok
  end

  def validate("", _options) do
    :ok
  end

  def validate(value, _options) do
    :ok
  end
end
