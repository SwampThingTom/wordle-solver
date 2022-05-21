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
private func takeTurn(solver _: Solver, validWords _: [Word]) -> [Word] {
    return []
}
