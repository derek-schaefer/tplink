defmodule TPLink.Network do
  import Bitwise

  @default_port 9999
  @default_key 0xAB
  @header_size 32
  @timeout 5_000

  def default_port, do: @default_port

  def address(value) when is_binary(value), do: String.to_charlist(value)
  def address(value), do: value

  def query_udp(address, payload, port \\ @default_port) do
    with {:ok, payload} <- encrypt(payload),
         {:ok, socket} <- :gen_udp.open(0, [:binary, active: false]),
         :ok <- :gen_udp.send(socket, address(address), port, payload),
         {:ok, {_address, _port, response}} <- :gen_udp.recv(socket, 0, @timeout),
         :ok <- :gen_udp.close(socket),
      do: decrypt(response)
  end

  def query_tcp(address, payload, port \\ @default_port) do
    with {:ok, payload} <- encrypt(payload),
         {:ok, socket} <- :gen_tcp.connect(address(address), port, [:binary, active: false], @timeout),
         :ok <- :gen_tcp.send(socket, add_header(payload)),
         {:ok, response} <- :gen_tcp.recv(socket, 0, @timeout),
         :ok <- :gen_tcp.close(socket),
      do: response |> remove_header |> decrypt
  end

  def add_header(payload) do
    <<byte_size(payload) :: size(@header_size)>> <> payload
  end

  def remove_header(<<header :: size(@header_size), payload::binary>>) do
    :binary.part(payload, 0, header)
  end

  def encrypt(payload, key \\ @default_key) do
    with {:ok, payload} <- Poison.encode(payload), do: {:ok, encrypt(payload, key, [])}
  end

  def decrypt(payload, key \\ @default_key) do
    payload |> decrypt(key, []) |> Poison.decode
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

  defp pack_buffer(buffer) do
    buffer |> Enum.reverse |> :binary.list_to_bin
  end
end
