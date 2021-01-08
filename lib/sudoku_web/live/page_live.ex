defmodule SudokuWeb.PageLive do
  use SudokuWeb, :live_view
  import SudokuWeb.PageView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, game: Sudoku.game(), selected: nil)}
  end

  @impl true
  def handle_event("select", %{"x" => x, "y" => y}, socket) do
    socket = socket |> assign(selected: {String.to_integer(x), String.to_integer(y)})

    {:noreply, socket}
  end

  @impl true
  def handle_event("put", %{"number" => number}, socket) do
    socket =
      case socket.assigns.selected do
        nil ->
          socket

        {x, y} ->
          socket
          |> assign(game: Sudoku.put(socket.assigns.game, x, y, String.to_integer(number)))
          |> assign(selected: nil)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("clear", %{}, socket) do
    socket =
      case socket.assigns.selected do
        nil ->
          socket

        {x, y} ->
          socket
          |> assign(game: Sudoku.put(socket.assigns.game, x, y, 0))
          |> assign(selected: nil)
      end

    {:noreply, socket}
  end
end
