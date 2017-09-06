defmodule Plustwo.Infrastructure.Validation.Validators.Url do
  @moduledoc "Check if a variable is URL."

  use Vex.Validator

  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok
  def validate(value, _options) do
    # regex obtained from https://stackoverflow.com/a/17773849/3372087
    case Regex.match?(~r/(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9]\.[^\s]{2,})/, value) do
      true -> :ok
      false -> {:error, "incorrect format"}
    end
  end
end
