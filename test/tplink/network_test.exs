defmodule TPLink.NetworkTest do
  use ExUnit.Case

  alias TPLink.Network

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
