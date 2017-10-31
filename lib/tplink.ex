defmodule TPLink do
  alias TPLink.{Network, Device}

  def device(address) do
    address
    |> Network.query_udp(Device.sysinfo_query)
    |> Device.init
  end
end
