defmodule TPLink.Network do
  import Bitwise

  alias TPLink.Device

  @default_port 9999
  @default_key 171
  @header_size 32

  def broadcast_socket do
    :gen_udp.open(0, [:binary, active: true, broadcast: true])
  end

  def broadcast_query(socket, port \\ @default_port) do
    :gen_udp.send(socket, {255, 255, 255, 255}, port, encrypt(Device.sysinfo_query))
  end

  def broadcast_close(socket) do
    :gen_udp.close(socket)
  end

  def query_udp(address, payload, port \\ @default_port) do
    {:ok, socket} = :gen_udp.open(0, [:binary, active: false])

    :ok = :gen_udp.send(socket, normalize_address(address), port, encrypt(payload))

    {:ok, {_address, _port, response}} = :gen_udp.recv(socket, 0)

    :ok = :gen_udp.close(socket)

    decrypt(response)
  end

  def query_tcp(address, payload, port \\ @default_port) do
    {:ok, socket} = :gen_tcp.connect(normalize_address(address), port, [:binary, active: false])

    :ok = :gen_tcp.send(socket, payload |> encrypt |> add_header)

    {:ok, response} = :gen_tcp.recv(socket, 0)

    :ok = :gen_tcp.close(socket)

    response |> remove_header |> decrypt
  end

  def add_header(payload) do
    <<byte_size(payload) :: size(@header_size)>> <> payload
  end

  def remove_header(<<header :: size(@header_size), payload::binary>>) do
    :binary.part(payload, 0, header)
  end

  def encrypt(payload, key \\ @default_key) do
    payload |> Poison.encode! |> encrypt(key, [])
  end

  def decrypt(payload, key \\ @default_key) do
    payload |> decrypt(key, []) |> Poison.decode!
  end

  defp encrypt(<<>>, _key, buffer) do
    pack_buffer(buffer)
  end
  defp encrypt(<<head, tail::binary>>, key, buffer) do
    encrypt(tail, head ^^^ key, [head ^^^ key | buffer])
  end

  defp decrypt(<<>>, _key, buffer) do
    pack_buffer(buffer)
  end
  defp decrypt(<<head, tail::binary>>, key, buffer) do
    decrypt(tail, head, [head ^^^ key | buffer])
  end

  defp normalize_address(address) when is_binary(address) do
    String.to_charlist(address)
  end
  defp normalize_address(address) do
    address
  end

  defp pack_buffer(buffer) do
    buffer |> Enum.reverse |> :binary.list_to_bin
  end
end
