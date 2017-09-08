defmodule Plustwo.Domain.AppOrgs.Validators.AppOrgUuidMustExist do
  @moduledoc false

  use Vex.Validator

  alias Plustwo.Domain.AppOrgs

  def validate("", _context) do
    :ok
  end

  def validate(nil, _context) do
    :ok
  end

  def validate(value, _context) do
    case AppOrgs.get_app_org_by_uuid(value) do
      nil ->
        {:error, "does not exist"}

      _ ->
        :ok
    end
  end
end
