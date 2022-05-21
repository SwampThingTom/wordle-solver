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
}
