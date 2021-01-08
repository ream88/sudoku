defmodule SudokuWeb.PageView do
  use SudokuWeb, :view

  def border_classes(x, y) do
    border_t(x, y) <> " " <> border_r(x, y) <> " " <> border_b(x, y) <> " " <> border_l(x, y)
  end

  def border_t(_x, y) when y in [1, 4, 7], do: "border-t-4"
  def border_t(_x, _y), do: "border-t"

  def border_r(x, _y) when x == 9, do: "border-r-4"
  def border_r(_x, _y), do: ""

  def border_b(_x, y) when y == 9, do: "border-b-4"
  def border_b(_x, _y), do: ""

  def border_l(x, _y) when x in [1, 4, 7], do: "border-l-4"
  def border_l(_x, _y), do: "border-l"

  def render_candidates(game, x, y) do
    game |> Sudoku.candidates(x, y) |> Enum.join(", ")
  end
end
