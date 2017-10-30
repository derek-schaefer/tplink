defmodule TPLink.NetworkTest do
  use ExUnit.Case

  alias TPLink.Network

  @sysinfo %{"system" => %{"get_sysinfo" => %{}}}

  setup do
    {:ok, address: "TPLINK_ADDRESS" |> System.get_env |> String.to_charlist}
  end

  describe "#query_udp" do
    @tag :external
    test "sends and receives a sysinfo query to and from a device", %{address: address} do
      assert @sysinfo = Network.query_udp(address, @sysinfo)
    end
  end

  describe "#encrypt" do
    test "encodes and encrypts a map" do
      assert Network.encrypt(%{"a" => 1}) == <<208, 242, 147, 177, 139, 186, 199>>
    end
  end

  describe "#decrypt" do
    test "decrypts and decodes a map" do
      assert Network.decrypt(<<208, 242, 147, 177, 139, 186, 199>>) == %{"a" => 1}
    end
  end
end
