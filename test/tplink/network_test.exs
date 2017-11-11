defmodule TPLink.NetworkTest do
  use ExUnit.Case

  alias TPLink.{Network, Device, Environment}

  @sysinfo Device.sysinfo_query

  setup do
    {:ok, address: Environment.address}
  end

  describe "#default_port" do
    test "returns an integer" do
      assert Network.default_port |> is_integer
    end
  end

  describe "#address" do
    test "accepts and returns a tuple" do
      assert Network.address({1, 1, 1, 1}) == {1, 1, 1, 1}
    end

    test "accepts and returns a charlist" do
      assert Network.address('1.1.1.1') == '1.1.1.1'
    end

    test "accepts a string and returns a charlist" do
      assert Network.address("1.1.1.1") == '1.1.1.1'
    end

    test "accepts and returns nil" do
      assert Network.address(nil) == nil
    end
  end

  describe "#query_udp" do
    @tag :external
    test "sends and receives a sysinfo query to and from a device", %{address: address} do
      assert {:ok, @sysinfo} = Network.query_udp(address, @sysinfo)
    end
  end

  describe "#query_tcp" do
    @tag :external
    test "sends and receives a sysinfo query to and from a device", %{address: address} do
      assert {:ok, @sysinfo} = Network.query_tcp(address, @sysinfo)
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
      assert Network.encrypt(%{"a" => 1}) == {:ok, <<208, 242, 147, 177, 139, 186, 199>>}
    end

    test "returns an error if the payload cannot be encoded" do
      assert Network.encrypt(self()) == {:error, {:invalid, self()}}
    end
  end

  describe "#decrypt" do
    test "decrypts and decodes a map" do
      assert Network.decrypt(<<208, 242, 147, 177, 139, 186, 199>>) == {:ok, %{"a" => 1}}
    end

    test "returns an error if the payload cannot be decoded" do
      assert Network.decrypt("invalid") == {:error, :invalid, 0}
    end
  end
end
