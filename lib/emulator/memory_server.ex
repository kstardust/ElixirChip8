defmodule Chip8.MemoryServer do
  alias Chip8.Memory
  alias Core.Stateful

  @behaviour Core.StatefulBehavior

  def start(args \\ nil) do
    Stateful.start(__MODULE__, args)
  end

  @impl true
  def init(_args) do
    Memory.init()
  end

  @impl true
  def handle_call({:read, addr}, state) do
    {value, new_state} = Memory.read(state, addr)
    {:reply, value, new_state}
  end

  def handle_call({:write, addr, value}, state) do
    {value, new_state} = Memory.write(state, addr, value)
    {:reply, value, new_state}
  end

  @impl true
  def handle_cast(_, state), do: {:noreply, state}

  def read(pid, addr) do
    Stateful.call(pid, {:read, addr})
  end

  def write(pid, addr, value) do
    Stateful.call(pid, {:write, addr, value})
  end
end
