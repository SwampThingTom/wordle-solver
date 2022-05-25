// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

import Foundation
import WordleSolver

let DefaultStartWord = word("TRACE")

func findBestStartWord(wordList: [Word]) {
    guard let solution = wordList.first else { fatalError("No words in word list.") }
    let bestStartWord = Solver(solution: solution).bestWord(from: wordList)
    print("The best start word according to the current heuristic is '\(String(bestStartWord))'.")
}

/// Attempts to guess the solution from the list of words.
/// Returns the number of turns it took to solve.
func play(puzzle: Puzzle, startWord: Word? = nil, verbose: Bool = true) -> [(Word, Clue)] {
    let startWord = startWord ?? DefaultStartWord
    let solver = Solver(solution: puzzle.solution, startWord: startWord)
    var remainingWords = puzzle.solutions
    var result = [(Word, Clue)]()
    var turn = 0
    while true {
        turn += 1
        if verbose {
            print("Turn #\(turn)")
            print("There \(remainingWords.count == 1 ? "is only 1 word" : "are \(remainingWords.count) words") left.")
        }

        let guess = solver.bestWord(from: remainingWords, isFirstGuess: turn == 1)
        let clue = solver.clue(for: guess)
        print(format(guess: guess, clue: clue))
        result.append((guess, clue))
        if clue == solver.solved {
            break
        }

        remainingWords = solver.wordsMatching(clue: clue, for: guess, in: remainingWords)
        guard !remainingWords.isEmpty else { fatalError("No words match the clue for \(guess).") }
    }
    return result
}

/// Returns a Wordle shareable game result.
/// WordleSolver 338 4/6
/// ⬛⬛⬛⬛🟩
/// ⬛⬛🟨⬛🟩
/// ⬛🟩🟩🟩🟩
/// 🟩🟩🟩🟩🟩
func formatShareableResult(_ game: [(Word, Clue)], puzzleNumber: Int) -> String {
    "WordleSolver \(puzzleNumber) \(turns(for: game))/6\n\n" +
        game[0 ..< min(game.count, 6)].map { shareableClue($0.1) }.joined(separator: "\n")
}

private func shareableClue(_ clue: Clue) -> String {
    clue.map { $0.sharable }.joined()
}

private func turns(for game: [(Word, Clue)]) -> String {
    return game.count <= 6 ? String(game.count) : "x"
}

/// Return a formatted string that colors the letters in a guessed word based on the clue.
private func format(guess: Word, clue: Clue) -> String {
    guess.enumerated().map { ($1, clue[$0]) }
        .reduce("") { partialResult, letterClue in
            "\(partialResult)\(letterClue.1.color)\(letterClue.0)"
        } + LetterClue.resetColor
}

extension LetterClue {
    static let notInWordColor = "\u{001B}[0;100m"
    static let inWordColor = "\u{001B}[0;103m"
    static let inPositionColor = "\u{001B}[42m"
    static let resetColor = "\u{001B}[0m"

    var color: String {
        switch self {
        case .notInWord: return Self.notInWordColor
        case .inWord: return Self.inWordColor
        case .inPosition: return Self.inPositionColor
        }
    }

    var sharable: String {
        switch self {
        case .notInWord: return "⬛"
        case .inWord: return "🟨"
        case .inPosition: return "🟩"
        }
    }
}
