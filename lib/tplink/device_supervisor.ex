defmodule TPLink.DeviceSupervisor do
  use Supervisor

  alias TPLink.{DeviceRegistry, DeviceService}

  #
  # Client
  #

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_service(address) do
    case Supervisor.start_child(__MODULE__, [address]) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
      {:error, reason} -> {:error, reason}
    end
  end

  def processes do
    Supervisor.which_children(__MODULE__) |> Enum.map(&elem(&1, 1))
  end

  def addresses do
    processes()
    |> Enum.map(&DeviceRegistry.keys/1)
    |> Enum.map(&List.first/1)
    |> Enum.sort
  end

  def services do
    addresses() |> Enum.map(&DeviceService.state/1)
  end

  #
  # Server
  #

  def init(_options) do
    children = [
      worker(DeviceService, [], restart: :temporary)
    ]

    options = [
      strategy: :simple_one_for_one
    ]

    Supervisor.init(children, options)
  end
end
