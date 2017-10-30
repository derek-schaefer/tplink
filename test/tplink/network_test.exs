defmodule TPLink.NetworkTest do
  use ExUnit.Case

  alias TPLink.Network

  @sysinfo %{"system" => %{"get_sysinfo" => %{}}}

  setup do
    {:ok, address: System.get_env("TPLINK_ADDRESS")}
  end

  describe "#query_udp" do
    @tag :external
    test "sends and receives a sysinfo query to and from a device", %{address: address} do
      assert @sysinfo = Network.query_udp(address, @sysinfo)
    end
  end

  describe "#query_tcp" do
    @tag :external
    test "sends and receives a sysinfo query to and from a device", %{address: address} do
      assert @sysinfo = Network.query_tcp(address, @sysinfo)
    end
  end

  describe "#add_header" do
    test "adds the header for an empty payload" do
      assert Network.add_header(<<>>) == <<0, 0, 0, 0>>
    end

    test "adds the header for a one byte payload" do
      assert Network.add_header(<<1>>) == <<0, 0, 0, 1, 1>>
    end
  end

  describe "#remove_header" do
    test "removes the header for an empty payload" do
      assert Network.remove_header(<<0, 0, 0, 0>>) == <<>>
    end

    test "removes the header for a one byte payload" do
      assert Network.remove_header(<<0, 0, 0, 1, 1>>) == <<1>>
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
