defmodule CpuTest do
  use ExUnit.Case
  alias Chip8.CPU

  test "test struct" do
    cpu = %CPU{}
    IO.inspect(cpu)
  end

end
