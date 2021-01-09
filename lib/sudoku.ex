defmodule Sudoku do
  @game [
    [0, 8, 9, 0, 0, 0, 0, 0, 0],
    [1, 0, 0, 3, 0, 0, 0, 0, 0],
    [0, 7, 0, 0, 0, 1, 8, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 6, 0],
    [0, 0, 0, 0, 0, 9, 0, 5, 0],
    [9, 0, 1, 7, 4, 0, 0, 0, 0],
    [0, 0, 5, 8, 0, 0, 0, 4, 0],
    [3, 0, 8, 0, 0, 0, 0, 1, 0],
    [0, 0, 0, 0, 2, 0, 0, 0, 6]
  ]

  @candidates [1, 2, 3, 4, 5, 6, 7, 8, 9]

  def game do
    @game
  end

  def solve(game) do
    game
    |> candidates()
    |> Enum.find(fn {_, v} -> length(v) == 1 end)
    |> case do
      {{x, y}, [candidate]} ->
        game |> put(x, y, candidate) |> solve

      nil ->
        game
    end
  end

  def candidates(game) do
    for y <- 1..9, x <- 1..9, into: %{}, do: {{x, y}, candidates(game, x, y)}
  end

  def candidates(game, x, y) do
    {xs, ys} = find_box(x, y)

    cache =
      for y <- ys, x <- xs, reduce: %{} do
        cache ->
          cache
          |> Map.put_new_lazy({x, y}, fn ->
            calculate_candidates(game, x, y)
          end)
      end

    {candidates, other} = Map.pop!(cache, {x, y})
    other = other |> Map.values() |> List.flatten()

    case candidates |> Enum.filter(&(&1 not in other)) do
      [single] -> [single]
      _ -> candidates
    end
  end

  defp calculate_candidates(game, x, y) do
    horizontal_candidates = horizontal_candidates(game, x, y)
    vertical_candidates = vertical_candidates(game, x, y)
    box_candidates = box_candidates(game, x, y)

    @candidates
    |> Enum.filter(fn candidate ->
      candidate in horizontal_candidates and
        candidate in vertical_candidates and
        candidate in box_candidates
    end)
  end

  def horizontal_candidates(game, x, y) do
    case get(game, x, y) do
      0 ->
        used = for x <- 1..9, do: get(game, x, y)
        @candidates -- used

      _ ->
        []
    end
  end

  def vertical_candidates(game, x, y) do
    case get(game, x, y) do
      0 ->
        used = for y <- 1..9, do: get(game, x, y)
        @candidates -- used

      _ ->
        []
    end
  end

  def box_candidates(game, x, y) do
    case get(game, x, y) do
      0 ->
        {xs, ys} = find_box(x, y)
        used = for y <- ys, x <- xs, do: get(game, x, y)
        @candidates -- used

      _ ->
        []
    end
  end

  def find_box(x, y) do
    x = div(x - 1, 3) * 3 + 1
    y = div(y - 1, 3) * 3 + 1

    {x..(x + 2), y..(y + 2)}
  end

  def get(game, x, y) do
    game |> Enum.at(y - 1) |> Enum.at(x - 1)
  end

  def put(game, x, y, number) do
    List.update_at(game, y - 1, fn list ->
      List.update_at(list, x - 1, fn _ -> number end)
    end)
  end

  def solved?(game) do
    game |> List.flatten() |> Enum.all?(&(&1 > 0))
  end
end
