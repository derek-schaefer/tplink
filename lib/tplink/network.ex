defmodule TPLink.Network do
  import Bitwise

  @default_key 171

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

  defp pack_buffer(buffer) do
    buffer |> Enum.reverse |> :binary.list_to_bin
  end
end
