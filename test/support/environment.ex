defmodule TPLink.Environment do
  def address do
    System.get_env("TPLINK_ADDRESS")
  end
end
