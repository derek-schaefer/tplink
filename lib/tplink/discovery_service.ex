defmodule TPLink.DiscoveryService do
  use GenServer

  alias TPLink.{DeviceSupervisor, Device, Network}

  defstruct socket: nil

  #
  # Client
  #

  def start_link do
    GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__)
  end

  #
  # Server
  #

  def init(state) do
    {:ok, socket} = :gen_udp.open(0, [:binary, active: true, broadcast: true])

    :timer.send_interval(30_000, :broadcast)

    send(self(), :broadcast)

    {:ok, %{state | socket: socket}}
  end

  def handle_info(:broadcast, state) do
    {:ok, payload} = Device.sysinfo_query |> Network.encrypt

    :ok = :gen_udp.send(state.socket, {255, 255, 255, 255}, Network.default_port, payload)

    {:noreply, state}
  end

  def handle_info({:udp, _socket, address, _port, payload}, state) do
    {:ok, _pid} = with {:ok, _payload} = Network.decrypt(payload), do: DeviceSupervisor.start_service(address)

    {:noreply, state}
  end
end
