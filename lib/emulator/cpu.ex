defmodule Chips8.CPU.Macros do
  defmacro define_registers() do

    keys = Enum.map(
      ~w(0 1 2 3 4 5 6 7 8 9 a b c d e f i pc sp)a,
      &String.to_atom("reg_v#{&1}")
    )
    fields = Enum.map(keys, & {&1, 0})
    types = Enum.map(keys, & {&1, :integer})

    quote do
      defstruct unquote(fields)
      @type t :: %__MODULE__{
        unquote_splicing(types)
      }
    end
  end
end

defmodule Chip8.CPU do
  require Chips8.CPU.Macros
  alias Chips8.CPU.Macros

  Macros.define_registers()

end
