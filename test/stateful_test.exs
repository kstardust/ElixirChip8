defmodule Core.Test do
  use ExUnit.Case
  alias Core.Stateful

  defmodule TestBH do
    alias Core.Stateful

    @behaviour Core.StatefulBehavior

    def init(_args) do
      %{}
    end

    def handle_call({:put, key, value}, state) do
      {:reply, value, Map.put(state, key, value)}
    end

    def handle_call({:get, key}, state) do
      {:reply, Map.get(state, key), state}
    end

    def handle_call({:delete, key}, state) do
      {:reply, :ok, Map.delete(state, key)}
    end

    def handle_cast({:put, key, value}, state) do
      {:noreply, Map.put(state, key, value)}
    end

  end

  test "Stateful module" do
    {:ok, pid} = Stateful.start(TestBH, %{})

    assert Stateful.call(pid, {:put, :key1, :value1}) == :value1
    assert Stateful.call(pid, {:get, :key1}) == :value1
    assert Stateful.call(pid, {:delete, :key1}) == :ok
    assert Stateful.call(pid, {:get, :key1}) == nil

    Stateful.cast(pid, {:put, :key2, :value2})
    assert Stateful.call(pid, {:get, :key2}) == :value2
  end
end
