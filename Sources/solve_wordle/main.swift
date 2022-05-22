// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

import ArgumentParser
import Foundation
import WordleSolver

struct Repeat: ParsableCommand {
    @Argument(help: "The solution to use for the puzzle.")
    var solutionString: String?

    var solution: Word? {
        guard let solutionString = solutionString else { return nil }
        return word(solutionString)
    }

    mutating func run() throws {
        let allWords = readWordList().map(word(_:))
        let solution = self.solution ?? allWords.randomElement()!
        play(wordList: allWords, solution: solution)
    }

    func readWordList() -> [String] {
        try! String(contentsOfFile: "Resources/wordle-list.txt", encoding: .utf8).components(separatedBy: .newlines)
    }
}

Repeat.main()
