// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

import Foundation
import WordleSolver

let allWords = readWordList().map(word(_:))

play(wordList: allWords, solution: allWords.randomElement()!)

func readWordList() -> [String] {
    try! String(contentsOfFile: "Resources/wordle-list.txt", encoding: .utf8).components(separatedBy: .newlines)
}
