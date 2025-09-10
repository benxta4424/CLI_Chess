

# CLI_Chess

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technical Structure](#technical-structure)
- [Setup](#setup)
- [How to Play](#how-to-play)
- [Game Examples](#game-examples)
	- [Multiple Endangered Pieces](#example-multiple-endangered-pieces)
	- [Normal Playing Session](#example-normal-playing-session-game-start)
	- [Queen's Multiple Moves](#example-queens-multiple-moves)
- [Testing](#testing)
- [Design Notes](#design-notes)
- [License](#license)


## Overview


**CLI_Chess** is a fully interactive, object-oriented chess game implemented in Ruby for the command line. It features a robust board representation, move validation, check/checkmate/stalemate detection, pawn promotion, and colored output for an enhanced terminal experience. The codebase is modular, with each chess piece encapsulated in its own class, and the game logic managed by the `Board` class.

The game is designed for two human players sharing a terminal. All chess rules are enforced, and the board is updated in real time with colorized output for clarity. The codebase is structured for extensibility and testing.


## Features

- Full chess rules: legal moves, check, checkmate, stalemate
- Pawn promotion (to Queen, Rook, Bishop, or Knight)
- Captured pieces tracking and display per player
- Visual highlighting of possible moves and endangered pieces (with colored squares)
- Two-player mode with player name and color selection
- Colorized board output (requires the `colorize` gem)
- Modular, object-oriented design for easy extension
- RSpec test suite for board and move logic


## Technical Structure

- `main.rb`: Entry point for a full chess game session
- `lib/board.rb`: Board state, move logic, and game flow
- `lib/piece.rb` and subclasses: Piece-specific movement and symbol logic (King, Queen, Rook, Bishop, Knight, Pawn)
- `lib/players.rb`: Player data and color selection
- `spec/`: RSpec tests for board and move logic


## Setup

1. Install Ruby (2.7+ recommended)
2. Install the `colorize` gem:
	```sh
	gem install colorize
	```
3. Clone this repository and navigate to the project folder.
4. Run the game:
	```sh
	ruby main.rb
	```

## How to Play

1. Start the game with `ruby main.rb`.
2. Each player enters their name and selects a color (white or black).
3. The board is displayed with coordinates. Players take turns selecting a piece and a destination square by entering X and Y coordinates (0-7).
4. The game enforces legal moves, check, checkmate, stalemate, and pawn promotion.
5. Captured pieces are tracked and displayed for each player.
6. The game ends with checkmate or stalemate, and the winner (or draw) is announced.


## Game Examples

### Example: Normal Playing Session (Game Start)
![alt text](normalboard.png)

```
Creating player ONE!
Name: Alice
Available colors:
0.white
1.black
Your choice: 0
Creating player TWO!
Name: Bob
The remaining color is: ["black"]

	0  1  2  3  4  5  6  7
0 ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜ 0
1 ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟ 1
2   .   .   .   .   .   .   .   . 2
3   .   .   .   .   .   .   .   . 3
4   .   .   .   .   .   .   .   . 4
5   .   .   .   .   .   .   .   . 5
6 ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙ 6
7 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ 7
	0  1  2  3  4  5  6  7

Alice pick a white piece please
pick your X piece: 6
pick your Y piece: 4
Possible moves highlighted in red...
pick your X move: 4
pick your Y move: 4
... (game continues)
```

*Tip: The board is always shown with coordinates for easy move selection. All moves are validated, and illegal moves are rejected with a helpful message.*



### Example: Queen's Multiple Moves


The queen can move in any straight line (horizontal, vertical, diagonal). Below is a demonstration of the queen's possible moves from the center of an empty board. The game will highlight all valid destinations for the queen, making it easy to visualize her power:

```
	0  1  2  3  4  5  6  7
0   .   .   .   ●   .   .   .   .
1   .   .   ●   .   ●   .   .   .
2   .   ●   .   .   .   ●   .   .
3   ●   .   .   ♕   .   .   ●   .
4   .   ●   .   .   .   ●   .   .
5   .   .   ●   .   ●   .   .   .
6   .   .   .   ●   .   .   .   .
7
	0  1  2  3  4  5  6  7
```
*Legend: ♕ = Queen, ● = Possible move*

![alt text](reginamiscari.png)

## Testing


Run all RSpec tests:
```sh
rspec
```
Tests cover board logic, move validation, check/checkmate/stalemate, and piece placement. You can add your own tests in the `spec/` directory.

## Design Notes

- **Extensibility:** The codebase is modular and can be extended to support additional features such as AI opponents, move history, or network play.
- **Terminal UI:** Uses Unicode chess symbols and colorized backgrounds for a clear, visually appealing CLI experience.
- **Testing:** RSpec is used for unit and integration tests. The board and move logic are thoroughly tested.
- **Performance:** Designed for responsiveness in the terminal, with efficient board updates and minimal flicker.
- **Limitations:** Currently supports only two human players in the same terminal session. No save/load functionality yet.

## Troubleshooting & Tips

- If you see strange characters, ensure your terminal supports Unicode.
- If colors do not appear, check that the `colorize` gem is installed and your terminal supports ANSI colors.
- For best experience, use a terminal with a dark or neutral background.



## License

MIT License. See source for details.