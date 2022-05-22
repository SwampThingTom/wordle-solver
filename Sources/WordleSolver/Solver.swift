// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

import Foundation

/// A clue for a specific letter in a guess.
public enum LetterClue {
    case notInWord, inWord, inPosition
}

/// A clue for all of the letters in a guess.
public typealias Clue = [LetterClue]

/// A word.
public typealias Word = [Character]

/// Returns a `Word` for a string.
public func word(_ str: String) -> Word {
    Array(str.uppercased())
}

/// Provides the functionality used to solve a Wordle puzzle.
public struct Solver {
    /// The solution for the current puzzle.
    public let solution: Word

    /// The clue that indicates the puzzle was solved.
    public let solved: Clue

    /// Returns an initialized `Solver` object.
    public init(solution: Word) {
        self.solution = solution
        solved = Array(repeating: LetterClue.inPosition, count: solution.count)
    }

    /// Returns the best guess from a list of valid words.
    public func bestWord(from wordList: [Word]) -> Word {
        guard var bestGuess = wordList.first else { fatalError("Word list is empty.") }
        if wordList.count == 1 { return bestGuess }

        var leastRemainingSolutions = Int.max
        for guess in wordList {
            var groups = [Clue: Int]()
            for solution in wordList {
                let clue = clue(for: guess, solution: solution)
                let totalCount = groups[clue] ?? 0
                groups[clue] = totalCount + 1
            }
            // Each group represents the number of times a particular clue appeared across all possible solutions.
            // So to calculate the remaining solutions, sum the squares of each count.
            let remainingSolutions = groups.reduce(0) { $0 + $1.1 * $1.1 }
            // print("'\(guess)' has \(remainingSolutions) remaining solutions.")
            if remainingSolutions < leastRemainingSolutions {
                bestGuess = guess
                leastRemainingSolutions = remainingSolutions
            }
        }

        return bestGuess
    }

    /// Returns the average number of remaining words if the given word is guessed for each possible solution.
    private func averageRemainingWords(for word: Word, in wordList: [Word]) -> Double {
        let totalRemainingWords = wordList.reduce(0) { result, _ in
            let remainingWords = wordsMatching(clue: clue(for: word), for: word, in: wordList)
            return result + remainingWords.count
        }
        return Double(totalRemainingWords) / Double(wordList.count)
    }

    /// Returns the clue for a guess.
    public func clue(for guess: Word, solution: Word? = nil) -> Clue {
        let solution = solution ?? self.solution
        assert(guess.count == solution.count)

        var result = Array(repeating: LetterClue.notInWord, count: solution.count)
        var found = Array(repeating: false, count: solution.count)

        // Find letters that are in the correct position.
        for (index, letter) in guess.enumerated() {
            if solution[index] == letter {
                assert(!found[index])
                found[index] = true
                result[index] = .inPosition
            }
        }

        // Find letters that are in the word but not in the correct position.
        for (guessIndex, letter) in guess.enumerated() {
            guard result[guessIndex] == .notInWord else { continue }
            for solutionIndex in 0 ..< solution.count {
                guard !found[solutionIndex] else { continue }
                if solution[solutionIndex] == letter {
                    found[solutionIndex] = true
                    result[guessIndex] = .inWord
                    break
                }
            }
        }

        return result
    }

    /// Returns the list of words that are valid next guesses for a given guess and its clue.
    public func wordsMatching(clue: Clue, for guess: Word, in possibleWords: [Word]) -> [Word] {
        possibleWords.filter { clue == self.clue(for: guess, solution: $0) }
    }
}
