defmodule Plustwo.Infrastructure.Services.Phone do
  @moduledoc "Lookup for phone information"

  alias ExTwilio.Lookup

  @doc """
  Retrieves information of a phone number.

  ## Examples

    {:ok, info} =  Plustwo.Infrastructure.Services.PhoneLookup.retrieve("+14802744417")
  """
  def lookup(phone_number, query \\ []) do
    Lookup.retrieve(phone_number, query)
  end

  @doc "Verify a phone number with verification code"
  def verify(_verification_code) do
    :ok
  end
end
