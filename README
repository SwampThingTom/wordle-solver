# Wordle Solver

Wordle Solver does just what you'd expect.

## Building

To build:

```
swift build
```

The binary will be placed in the `./build` directory.

## Run Tests

To run tests:

```
swift test
```

## Running

To run Wordle Solver:

```
.build/debug/solve-wordle
```

Wordle Solver has a few command line options.

```
USAGE: solve-wordle [<solution-string>] [--start <start>] [--all] [--best-start]

ARGUMENTS:
  <solution-string>       The solution to use for the puzzle.

OPTIONS:
  --start <start>         The word to use as a first guess.
  --all                   Solve all possible puzzles.
  --best-start            Solve best start word.
  -h, --help              Show help information.
```

## Version Info

Wordle Solver is under active development.

### Version 0.1

The `bestWord(from:)` function simply chooses a random word from the remaining word list.

Running `solve-wordle --all` produced:

```
It took an average of 4.1 turns to solve all Wordles.
48 puzzles were not solved.
```

### Version 0.2

The `bestWord(from:)` function chooses the word that has the fewest remaining options for all
possible solutions.
That is, it will have the fewest average solutions after guessing it.

Running `solve-wordle --best-start` produced:

```
The best start word according to the current heuristic is 'RAISE'.
```

Because of that, 'RAISE' has been hardcoded as the default start word so that it doesn't need
to be calculated every time.

The `--start <start>` option was added to override the default start word.

Finally, running `solve-wordle --all` produced:

```
It took an average of 3.6 turns to solve all Wordles.
14 puzzles were not solved.
```
