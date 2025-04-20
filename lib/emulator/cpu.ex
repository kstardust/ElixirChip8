defmodule Chips8.CPU.Macros do
  defmacro define_registers() do
    general_purpose_suffixes = Enum.to_list(?0..?9) ++ Enum.to_list(?a..?f)
    keys = Enum.map(general_purpose_suffixes, & String.to_atom("reg_v#{<<&1>>}"))
      ++ [:reg_i, :reg_pc, :reg_sp]
    fields = Enum.map(keys, & {&1, 0})

    quote do
      defstruct unquote(fields)
    end
  end
end

defmodule Chip8.CPU do
  require Chips8.CPU.Macros
  alias Chips8.CPU.Macros

  Macros.define_registers()

end
