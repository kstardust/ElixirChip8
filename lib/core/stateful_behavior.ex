defmodule Core.StatefulBehavior do
  @callback init(args :: any()) :: any()
  @callback handle_call(message :: any(), state :: any()) :: {:reply, reply :: any(), new_state :: any()}
  @callback handle_cast(message :: any(), state :: any()) :: {:noreply, new_state :: any()}
end
