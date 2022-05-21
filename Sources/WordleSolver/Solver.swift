// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

import Foundation

public enum LetterClue {
    case notInWord, inWord, inPosition
}

public typealias Clue = [LetterClue]

public typealias Word = [Character]

public func word(_ str: String) -> Word {
    Array(str.uppercased())
}

public struct Solver {
    public let solution: Word
    public let solved: Clue

    public init(solution: Word) {
        self.solution = solution
        solved = Array(repeating: LetterClue.inPosition, count: solution.count)
    }

    public func bestWord(from wordList: [Word]) -> Word {
        guard let word = wordList.randomElement() else {
            fatalError("Unable to choose a word from \(wordList)")
        }
        return word
    }

    public func clue(for guess: Word) -> Clue {
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

    public func wordsMatching(clue _: Clue, for _: Word, in _: [Word]) -> [Word] {
        return []
    }
}
