defmodule Puzzle15Web.PageController do
  use Puzzle15Web, :controller

  #orginal grid
  @initial_puzzle [
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
    13, 14, 15, nil
  ]

  def index(conn, _params) do
    #shuffling initially
    puzzle = shuffle_puzzle(@initial_puzzle)
    render(conn, "index.html", puzzle: puzzle, initial_puzzle: @initial_puzzle)
  end

  def shuffle_puzzle(puzzle) do
    Enum.shuffle(puzzle)
  end
end
