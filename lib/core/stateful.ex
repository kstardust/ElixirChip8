defmodule Core.Stateful do

  def start(module, args) do
    {:ok, spawn(fn ->
      state = module.init(args)
      loop(module, state)
    end)}
  end

  def loop(module, state) do
    receive do
      {:call, from, message} ->
        {:reply, response, new_state} = module.handle_call(message, state)
        send(from, {:reply, response})
        loop(module, new_state)
      {:cast, _from, message} ->
        {:noreply, new_state} = module.handle_cast(message, state)
        loop(module, new_state)
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, self(), message})
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})
    receive do
      {:reply, response} -> response
    after
      5000 -> :timeout
    end
  end
end
