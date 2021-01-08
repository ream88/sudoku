defmodule SudokuWeb.PageLiveTest do
  use SudokuWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Sudoku"
    assert render(page_live) =~ "Sudoku"
  end
end
