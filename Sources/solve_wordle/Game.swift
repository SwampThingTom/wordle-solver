// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

import Foundation
import WordleSolver

/// Attempts to guess the solution from the list of words.
func play(wordList: [Word], solution: Word) {
    let solver = Solver(solution: solution)
    var remainingWords = wordList
    var turn = 0
    repeat {
        turn += 1
        print("Turn #\(turn)")
        print("There are \(remainingWords.count) words left.")
        remainingWords = takeTurn(solver: solver, validWords: remainingWords)
    } while !remainingWords.isEmpty
    print("Solved in \(turn) \(turn == 1 ? "turn" : "turns")")
}

/// Picks a word from `validWords` to use as a guess.
/// Returns the list of `validWords` that match the clue for that guess,
/// or an empty array if the guess was correct.
private func takeTurn(solver: Solver, validWords: [Word]) -> [Word] {
    let guess = solver.bestWord(from: validWords)
    let clue = solver.clue(for: guess)
    print("Guess: \(format(guess: guess, clue: clue))")
    guard clue != solver.solved else {
        print("Solved!")
        return []
    }
    let remainingWords = solver.wordsMatching(clue: clue, for: guess, in: validWords)
    guard !remainingWords.isEmpty else { fatalError("No words match the clue for \(guess).") }
    return remainingWords
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
}
