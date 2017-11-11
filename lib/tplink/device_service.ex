defmodule TPLink.DeviceService do
  use GenServer

  alias TPLink.{DeviceRegistry, Device, Network}

  defstruct address: nil, socket: nil, status: :offline, device: nil, attempts: 0

  @attempts 2

  #
  # Client
  #

  def start_link(address) do
    GenServer.start_link(__MODULE__, %__MODULE__{address: address}, name: via_tuple(address))
  end

  def state(address) do
    GenServer.call(via_tuple(address), :state)
  end

  #
  # Server
  #

  def init(state) do
    {:ok, socket} = :gen_udp.open(0, [:binary, active: true])

    :timer.send_interval(5_000, :request)

    send(self(), :request)

    {:ok, %{state | socket: socket}}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:request, state) do
    if state.attempts >= @attempts * 2, do: throw({:offline, state.attempts}), else: nil

    {:ok, payload} = Device.sysinfo_query |> Network.encrypt

    :ok = :gen_udp.send(state.socket, state.address, Network.default_port, payload)

    status = if state.status != :online || state.attempts >= @attempts, do: :offline, else: :online

    {:noreply, %{state | status: status, attempts: state.attempts + 1}}
  end

  def handle_info({:udp, _socket, address, _port, payload}, state) do
    {:ok, payload} = Network.decrypt(payload)

    device = Device.init(payload, address)

    state = %{state | status: :online, attempts: 0, device: device}

    :ok = DeviceRegistry.dispatch({:device, state})

    {:noreply, state}
  end

  defp via_tuple(address) do
    {:via, Registry, {DeviceRegistry, address}}
  end
end
