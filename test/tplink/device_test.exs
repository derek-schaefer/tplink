defmodule TPLink.DeviceTest do
  use ExUnit.Case

  alias TPLink.Device

  describe "#sysinfo_query" do
    test "returns the nested query map" do
      assert Device.sysinfo_query["system"]["get_sysinfo"] == %{}
    end
  end

  describe "#init" do
    test "initializes a struct with data" do
      assert Device.init(%{}) == %Device{data: %{}, address: nil}
    end

    test "initializes a struct with data and an address" do
      assert Device.init(%{}, '1.1.1.1') == %Device{data: %{}, address: '1.1.1.1'}
    end

    test "converts a string address to a charlist" do
      assert Device.init(%{}, "1.1.1.1") == %Device{data: %{}, address: '1.1.1.1'}
    end
  end

  describe "#sysinfo" do
    test "returns the nested sysinfo" do
      assert 1 |> device |> Device.sysinfo == 1
    end
  end

  describe "#id" do
    test "returns the nested id" do
      assert %{"deviceId" => "1"} |> device |> Device.id == "1"
    end
  end

  describe "#model" do
    test "returns the nested model" do
      assert %{"model" => "1"} |> device |> Device.model == "1"
    end
  end

  describe "#name" do
    test "returns the nested name" do
      assert %{"alias" => "1"} |> device |> Device.name == "1"
    end
  end

  defp device(sysinfo) do
    %Device{data: %{"system" => %{"get_sysinfo" => sysinfo}}}
  end
end
