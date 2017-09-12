defmodule Plustwo.Domain.AppAccounts.Workflows.CreateBusinessFromAppAccount do
  @moduledoc false

  use Commanded.Event.Handler,
      name: "AppAccounts.Workflows.CreateBusinessFromAppAccount"

  alias Plustwo.Domain.Router
  alias Plustwo.Domain.AppAccounts.Events.AppAccountRegistered
  alias Plustwo.Domain.AppAccounts.Notifications
  alias Plustwo.Domain.AppAccounts.Schemas.Business
  alias Plustwo.Domain.AppAccounts.Commands.CreateBusiness

  def handle(%AppAccountRegistered{app_account_uuid: app_account_uuid, type: 1},
             _metadata) do
    case create_business(%{app_account_uuid: app_account_uuid}) do
      {:ok, _business} ->
        :ok

      _ ->
        {:error, "unable to create business"}
    end
  end


  defp create_business(%{app_account_uuid: app_account_uuid} = attrs) do
    business_uuid = UUID.uuid4()
    command =
      attrs
      |> CreateBusiness.new()
      |> CreateBusiness.assign_business_uuid(business_uuid)
      |> CreateBusiness.assign_app_account_uuid(app_account_uuid)
    with {:ok, version} <-
           Router.dispatch(command, include_aggregate_version: true) do
      Notifications.wait_for Business, business_uuid, version
    else
      reply ->
        reply
    end
  end
end
