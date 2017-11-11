defmodule TPLink.Application do
  use Application

  import Supervisor.Spec

  alias TPLink.{DeviceRegistry, DeviceSupervisor, DiscoveryService}

  def start(_type, _args) do
    children = [
      supervisor(DeviceRegistry, []),
      supervisor(DeviceSupervisor, []),
      worker(DiscoveryService, [])
    ]

    options = [
      name: __MODULE__,
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end
