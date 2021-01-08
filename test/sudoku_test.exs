defmodule SudokuTest do
  use ExUnit.Case

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

  test "horizontal_candidates/3" do
    assert [1, 2, 3, 4, 5, 6, 7] == Sudoku.horizontal_candidates(@game, 1, 1)
    assert [] == Sudoku.horizontal_candidates(@game, 2, 1)
    assert [2, 3, 4, 5, 6, 9] == Sudoku.horizontal_candidates(@game, 1, 3)
  end

  test "vertical_candidates/3" do
    assert [2, 4, 5, 6, 7, 8] == Sudoku.vertical_candidates(@game, 1, 1)
    assert [] == Sudoku.vertical_candidates(@game, 1, 2)
    assert [1, 2, 4, 5, 6, 9] == Sudoku.vertical_candidates(@game, 4, 1)
  end

  test "box_candidates/3" do
    assert [2, 3, 4, 5, 6] == Sudoku.box_candidates(@game, 1, 1)
    assert [] == Sudoku.box_candidates(@game, 2, 1)
    assert [2, 3, 5, 7, 8, 9] == Sudoku.box_candidates(@game, 9, 8)
  end

  test "find_box/2" do
    assert {1, 1} == Sudoku.find_box(1, 1)
    assert {1, 4} == Sudoku.find_box(3, 5)
    assert {7, 7} == Sudoku.find_box(9, 9)
  end

  test "put/4" do
    assert 2 == @game |> Sudoku.put(1, 1, 2) |> Sudoku.get(1, 1)
    assert 2 == @game |> Sudoku.put(1, 3, 2) |> Sudoku.get(1, 3)
    assert 3 == @game |> Sudoku.put(5, 5, 3) |> Sudoku.get(5, 5)
  end
end
