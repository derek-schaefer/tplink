defmodule TPLinkTest do
  use ExUnit.Case

  alias TPLink.{Device, Environment}

  setup do
    {:ok, address: Environment.address}
  end

  describe "#device" do
    @tag :external
    test "queries and returns a device", %{address: address} do
      assert {:ok, %Device{}} = TPLink.device(address)
    end

    @tag :external
    test "returns errors when encountered" do
      assert {:error, _reason} = TPLink.device('1.1.1.1')
    end
  end
end
