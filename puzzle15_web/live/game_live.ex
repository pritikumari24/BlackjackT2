defmodule Puzzle15Web.GameLive do
  use Phoenix.LiveView
  alias Puzzle15Web.PageController

  @initial_puzzle [
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
    13, 14, 15, nil
  ]

  def render(assigns) do
    ~L"""
    <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; text-align: center;">
      <!-- Title -->
      <h1 style="font-size: 3rem; font-weight: bold; margin-bottom: 20px;">Puzzle 15</h1>

      <!-- Buttons -->
      <div style="margin-bottom: 20px;">
        <button phx-click="new_game" style="padding: 10px 20px; font-size: 1.2rem; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; margin-right: 10px;">
          New Game
        </button>
        <span style="font-size: 1.2rem; font-weight: bold;">Moves: <%= @moves %></span>
        <span style="font-size: 1.2rem; font-weight: bold; margin-left: 20px;">Time: <%= @time %> seconds</span>
      </div>

      <!-- Puzzle Grid -->
      <div id="puzzle-grid" style="display: grid; grid-template-columns: repeat(4, 100px); gap: 5px;">
        <%= for {number, index} <- Enum.with_index(@puzzle) do %>
          <div
            phx-click="move_tile"
            phx-value-tile="<%= number %>"
            class="puzzle-tile"
            style="width: 100px; height: 100px;
              background-color: <%= if number != nil and number == Enum.at(@initial_puzzle, index), do: '#FFA500', else: '#007bff' %>;
              text-align: center; line-height: 100px; color: white; font-size: 28px; font-weight: bold;
              text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3); letter-spacing: 2px;">
            <%= if number, do: number, else: "" %>
          </div>
        <% end %>
      </div>

      <!-- Instructions Text -->
      <p style="font-size: 1.2rem; margin-top: 20px; font-weight: bold;">Arrange the numbers 1 to 15 in order</p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    puzzle = PageController.shuffle_puzzle(@initial_puzzle)
    {:ok, assign(socket, puzzle: puzzle, moves: 0, time: 0, initial_puzzle: @initial_puzzle, timer_ref: nil)}
  end

  def handle_event("move_tile", %{"tile" => tile}, socket) do
    puzzle = move_tile(socket.assigns.puzzle, String.to_integer(tile))
    moves = if puzzle != socket.assigns.puzzle, do: socket.assigns.moves + 1, else: socket.assigns.moves
    {:noreply, assign(socket, puzzle: puzzle, moves: moves)}
  end

  def handle_event("new_game", _params, socket) do
    puzzle = PageController.shuffle_puzzle(@initial_puzzle)

    # Cancel the previous timer if it exists
    if socket.assigns.timer_ref do
      Process.cancel_timer(socket.assigns.timer_ref)
    end

    # Start a new timer for the new game
    timer_ref = Process.send_after(self(), :update_timer, 1000)

    {:noreply, assign(socket, puzzle: puzzle, moves: 0, time: 0, timer_ref: timer_ref)}
  end

  def handle_info(:update_timer, socket) do
    # Send the update again after 1 second to continue the timer
    timer_ref = Process.send_after(self(), :update_timer, 1000)
    {:noreply, assign(socket, time: socket.assigns.time + 1, timer_ref: timer_ref)}
  end

  defp move_tile(puzzle, tile) do
    empty_pos = Enum.find_index(puzzle, &(&1 == nil))
    tile_pos = Enum.find_index(puzzle, &(&1 == tile))

    if adjacent?(empty_pos, tile_pos) do
      List.replace_at(List.replace_at(puzzle, empty_pos, tile), tile_pos, nil)
    else
      puzzle
    end
  end

  defp adjacent?(empty_pos, tile_pos) do
    abs(empty_pos - tile_pos) == 1 or abs(empty_pos - tile_pos) == 4
  end
end
