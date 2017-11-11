defmodule TPLink.DeviceRegistry do
  @topic "devices"

  def start_link do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def keys(pid) do
    Registry.keys(__MODULE__, pid)
  end

  def register do
    Registry.register(__MODULE__, @topic, nil)
  end

  def unregister(key) do
    Registry.unregister(__MODULE__, key)
  end

  def dispatch(message) do
    Registry.dispatch(__MODULE__, @topic, &dispatch_to_subscribers(&1, message))
  end

  defp dispatch_to_subscribers(subscribers, message) do
    subscribers |> Enum.map(&elem(&1, 0)) |> Enum.each(&send(&1, message))
  end
end
