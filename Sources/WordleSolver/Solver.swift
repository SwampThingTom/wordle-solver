// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and 
// distribution of this software.

import Foundation

enum LetterClue {
    case notInWord, inWord, inPosition
}

typealias Clue = Array<LetterClue>

typealias Word = Array<Character>

func word(_ str: String) -> Word {
    Array(str.uppercased())
}

struct Solver {
}
