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

    public func clue(for _: Word) -> Clue {
        return Array(repeating: LetterClue.notInWord, count: solution.count)
    }

    public func wordsMatching(clue _: Clue, for _: Word, in _: [Word]) -> [Word] {
        return []
    }
}
