defmodule TPLink do
  alias TPLink.{Network, Device}

  def device(address) do
    with {:ok, payload} <- Network.query_tcp(address, Device.sysinfo_query),
      do: {:ok, Device.init(payload, address)}
  end
end
