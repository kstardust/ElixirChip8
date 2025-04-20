defmodule MemoryTest do
  use ExUnit.Case
  alias Chip8.MemoryServer

  setup do
    {:ok, pid} = MemoryServer.start()
    {:ok, pid: pid}
  end

  test "MemoryServer initializes with empty memory", %{pid: pid} do
    assert MemoryServer.read(pid, 0) == 0
    assert MemoryServer.read(pid, 1) == 0

    assert MemoryServer.write(pid, 0, 42) == 42
    assert MemoryServer.read(pid, 0) == 42

    assert MemoryServer.write(pid, 1, 100) == 100
    assert MemoryServer.read(pid, 1) == 100

    assert MemoryServer.write(pid, 2, 255) == 255
    assert MemoryServer.read(pid, 2) == 255

    assert MemoryServer.write(pid, 1, 0) == 0
    assert MemoryServer.read(pid, 1) == 0

    assert MemoryServer.read(pid, 2) == 255
  end

end
