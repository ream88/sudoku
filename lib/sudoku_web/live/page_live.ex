defmodule SudokuWeb.PageLive do
  use SudokuWeb, :live_view
  import SudokuWeb.PageView

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_game(Sudoku.game())
      |> assign(selected: nil)

    {:ok, socket}
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
          |> assign_game(Sudoku.put(socket.assigns.game, x, y, String.to_integer(number)))
          |> assign(selected: nil)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("clear", _params, socket) do
    socket =
      case socket.assigns.selected do
        nil ->
          socket

        {x, y} ->
          socket
          |> assign_game(Sudoku.put(socket.assigns.game, x, y, 0))
          |> assign(selected: nil)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("solve", _params, socket) do
    socket =
      socket
      |> assign_game(solve(socket.assigns.game))
      |> assign(selected: nil)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:solve, socket) do
    socket =
      socket
      |> assign_game(solve(socket.assigns.game))
      |> assign(selected: nil)

    {:noreply, socket}
  end

  defp assign_game(socket, game) do
    socket
    |> assign(game: game)
    |> assign(candidates: Sudoku.candidates(game))
  end

  defp solve(game) do
    game
    |> Sudoku.candidates()
    |> Enum.find(fn {_, v} -> length(v) == 1 end)
    |> case do
      {{x, y}, [candidate]} ->
        Process.send_after(self(), :solve, 1)
        game |> Sudoku.put(x, y, candidate)

      nil ->
        game
    end
  end
end
