defmodule Braintree.Integration.DisputeTest do
  use ExUnit.Case, async: true

  alias Braintree.Dispute

  @moduletag :integration

  test "find/1 fails for invalid dispute id" do
    assert {:error, :not_found} = Dispute.find("someinvalidid")
  end
end
