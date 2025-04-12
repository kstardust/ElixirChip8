defmodule Chip8 do

  def main(_args) do
    CursesUI.ui_init()
    forever()
  end

  def forever() do
    CursesUI.ui_step()
    forever()
  end
end
