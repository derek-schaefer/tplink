defmodule TPLink.DiscoveryService do
  use GenServer

  alias TPLink.{Network, Device}

  @state %{socket: nil, devices: %{}}

  #
  # Client
  #

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, @state, options)
  end

  def devices(pid) do
    GenServer.call(pid, :devices)
  end

  def broadcast(pid) do
    GenServer.cast(pid, :broadcast)
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  #
  # Server
  #

  def init(state) do
    {:ok, socket} = Network.broadcast_socket

    {:ok, %{state | socket: socket}}
  end

  def handle_call(:devices, _from, %{devices: devices} = state) do
    {:reply, devices, state}
  end

  def handle_cast(:broadcast, %{socket: socket} = state) do
    :ok = Network.broadcast_query(socket)

    {:noreply, state}
  end

  def handle_info({:udp, _socket, address, _port, payload}, %{devices: devices} = state) do
    device = payload |> Network.decrypt |> Device.init

    {:noreply, %{state | devices: Map.put(devices, address, device)}}
  end

  def terminate(_reason, %{socket: socket}) do
    Network.broadcast_close(socket)
  end
end
