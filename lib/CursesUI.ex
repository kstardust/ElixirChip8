defmodule CursesUI do
  @on_load :load_dynamic_libs

  def load_dynamic_libs() do
    :ok = :erlang.load_nif("./nif/ncurses_ui/ncurses_ui_nif", 0)
  end

  def ui_init(), do: :erlang.nif_error(:nif_not_loaded)

  def ui_step(), do: :erlang.nif_error(:nif_not_loaded)

end
