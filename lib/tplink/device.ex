defmodule TPLink.Device do
  alias TPLink.Network

  defstruct [:address, :data]

  def sysinfo_query do
    %{"system" => %{"get_sysinfo" => %{}}}
  end

  def init(data, address \\ nil) when is_map(data) do
    %__MODULE__{data: data, address: Network.address(address)}
  end

  def sysinfo(%__MODULE__{data: data}) do
    data["system"]["get_sysinfo"]
  end

  def id(%__MODULE__{} = device) do
    sysinfo(device)["deviceId"]
  end

  def model(%__MODULE__{} = device) do
    sysinfo(device)["model"]
  end

  def name(%__MODULE__{} = device) do
    sysinfo(device)["alias"]
  end
end
