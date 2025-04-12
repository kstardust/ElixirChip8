defmodule Chip8 do
  @screen_width 64
  @screen_height 32

  def main(_args) do
    CursesUI.ui_init(@screen_width, @screen_height)
    screen = for y <- 0..@screen_height - 1, x <- 0..@screen_width - 1, into: %{},
              do: {y * @screen_width + x, rem(y * @screen_width + x ,2)}
    forever(screen)
  end

  def forever(screen) do
    CursesUI.ui_draw(screen)
    CursesUI.ui_step()
    forever(screen)
  end
end
