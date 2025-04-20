defmodule Chip8.Memory do
  @memory_size 4096

  defstruct [
    data: %{},
  ]

  def init() do
    %__MODULE__{
      # I am using map to store the memory, because the performance is much
      # better than tuple, which requires a lot of copying.
      data: (for addr <- 0..@memory_size - 1, into: %{}, do: {addr, 0})
    }
  end

  def read(%__MODULE__{data: data} = memory, address) do
    # TODO: Check if address is valid
    {Map.get(data, address), memory}
  end

  def write(%__MODULE__{data: data} = memory, address, value) do
    # TODO: Check if address is valid
    {
      value,
      %__MODULE__{
        memory
        | data: Map.put(data, address, value)
      }
    }
  end
end
