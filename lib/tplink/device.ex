defmodule TPLink.Device do
  defstruct [:payload]

  def sysinfo_query, do: %{"system" => %{"get_sysinfo" => %{}}}

  def init(payload) when is_map(payload) do
    %__MODULE__{payload: payload}
  end

  def sysinfo(%__MODULE__{payload: payload}) do
    payload["system"]["get_sysinfo"]
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
