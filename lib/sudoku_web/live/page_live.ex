defmodule SudokuWeb.PageLive do
  use SudokuWeb, :live_view
  import SudokuWeb.PageView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, game: Sudoku.game())}
  end
end
