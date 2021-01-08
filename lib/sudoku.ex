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
    for x <- 1..9, y <- 1..9 do
      horizontal_candidates = horizontal_candidates(game, x, y)
      vertical_candidates = vertical_candidates(game, x, y)
      box_candidates = box_candidates(game, x, y)

      @candidates
      |> Enum.filter(fn candidate ->
        candidate in horizontal_candidates and
          candidate in vertical_candidates and
          candidate in box_candidates
      end)
      |> IO.inspect(label: "candidates at #{x}:#{y}", charlists: true)
      |> case do
        [candidate] -> IO.inspect(candidate, label: "candidate at #{x}:#{y}")
        _ -> nil
      end
    end
  end

  def horizontal_candidates(game, x, y) do
    case get(game, x, y) do
      0 ->
        used = for y <- 1..9, do: get(game, x, y)
        @candidates -- used

      _ ->
        []
    end
  end

  def vertical_candidates(game, x, y) do
    case get(game, x, y) do
      0 ->
        used = for x <- 1..9, do: get(game, x, y)
        @candidates -- used

      _ ->
        []
    end
  end

  def box_candidates(game, x, y) do
    case get(game, x, y) do
      0 ->
        {x, y} = find_box(x, y)
        used = for x <- x..(x + 2), y <- y..(y + 2), do: get(game, x, y)
        @candidates -- used

      _ ->
        []
    end
  end

  def find_box(x, y) do
    {div(x - 1, 3) * 3 + 1, div(y - 1, 3) * 3 + 1}
  end

  def get(game, x, y) do
    game |> Enum.at(x - 1) |> Enum.at(y - 1)
  end

  def solved?(game) do
    game |> List.flatten() |> Enum.all?(&(&1 > 0))
  end
end
