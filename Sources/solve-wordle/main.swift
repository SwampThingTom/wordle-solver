// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

import ArgumentParser
import Foundation
import WordleSolver

struct SolveWordle: ParsableCommand {
    @Argument(help: "The solution to use for the puzzle.")
    var solutionString: String?

    @Option(help: "The word to use as a first guess.")
    var start: String?

    @Flag(help: "Solve all possible puzzles.")
    var all = false

    @Flag(help: "Solve best start word.")
    var bestStart = false

    var solution: Word? {
        guard let solutionString = solutionString else { return nil }
        return word(solutionString)
    }

    var startWord: Word? {
        guard let start = start else { return nil }
        return word(start)
    }

    mutating func run() throws {
        let allWords = readWordList().map(word(_:))

        guard !bestStart else {
            findBestStartWord(wordList: allWords)
            return
        }

        guard !all else {
            playAllSolutions(wordList: allWords, startWord: startWord)
            return
        }

        let solution = self.solution ?? allWords.randomElement()!
        playSingleGame(wordList: allWords, solution: solution, startWord: startWord)
    }

    func playSingleGame(wordList: [Word], solution: Word, startWord _: Word?) {
        let turns = play(wordList: wordList, solution: solution, startWord: startWord)
        if turns < 7 {
            print("Solved in \(turns) \(turns == 1 ? "turn" : "turns.")")
        } else {
            print("Failed to solve Wordle in 6 turns.")
        }
    }

    func playAllSolutions(wordList: [Word], startWord _: Word?) {
        var totalTurns = 0
        var unsolved = 0
        for solution in wordList {
            let turns = play(wordList: wordList, solution: solution, startWord: startWord, quiet: true)
            totalTurns += turns
            if turns > 6 {
                unsolved += 1
            }
            print("'\(String(solution))' took \(turns) turns.")
        }
        let average = Double(totalTurns) / Double(wordList.count)
        print(String(format: "It took an average of %.1f turns to solve all Wordles.", average))
        print("\(unsolved) puzzles were not solved.")
    }

    func readWordList() -> [String] {
        try! String(contentsOfFile: "Resources/wordle-list.txt", encoding: .utf8).components(separatedBy: .newlines)
    }
}

SolveWordle.main()
