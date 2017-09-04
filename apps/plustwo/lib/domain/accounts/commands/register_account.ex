defmodule Plustwo.Domain.Accounts.Commands.RegisterAccount do
  @moduledoc false

  defstruct [
    uuid: "",
    is_org: "",
    handle_name: "",
    email: "",
  ]

  use Plustwo.Domain, :command
  alias Plustwo.Domain.Accounts.Commands.RegisterAccount
  alias Plustwo.Domain.Accounts.Validators.{
    UniqueAccountHandleName,
    #UniqueAccountPrimaryEmail,
  }

  validates :uuid,
    presence: true,
    uuid: true

  validates :is_org,
    #presence: true,
    boolean: true

  validates :handle_name,
    presence: true,
    string: true,
    handle_name: true,
    length: [min: 2],
    by: &UniqueAccountHandleName.validate/2

  validates :email,
    presence: true,
    string: true,
    email: true
    #by: &UniqueAccountPrimaryEmail.validate/2

  @doc "Assign a unique identity to account."
  def assign_uuid(%RegisterAccount{} = user, uuid) do
    %RegisterAccount{user | uuid: uuid}
  end

  @doc "Downcase account handle name."
  def downcase_handle_name(%RegisterAccount{handle_name: handle_name} = account) do
    %RegisterAccount{account | handle_name: String.downcase(handle_name)}
  end

  @doc "Downcase account's email."
  def downcase_email(%RegisterAccount{email: email} = account) do
    %RegisterAccount{account | email: String.downcase(email)}
  end
end
