// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

import ArgumentParser
import Foundation
import WordleSolver

struct SolveWordle: ParsableCommand {
    @Argument(help: "The solution to use for the puzzle. Can be a 5-letter word or the puzzle number.")
    var solution: String?

    @Option(help: "The word to use as a first guess.")
    var start: String?

    @Flag(help: "Use original Wordle solutions.")
    var wardle = false

    @Flag(help: "Solve all possible puzzles.")
    var all = false

    @Flag(help: "Solve best start word.")
    var bestStart = false

    @Flag(help: "Show verbose text when solving.")
    var verbose = false

    var startWord: Word? {
        guard let start = start else { return nil }
        return word(start)
    }

    mutating func run() throws {
        let allSolutions = readSolutions()

        guard !bestStart else {
            findBestStartWord(wordList: allSolutions)
            return
        }

        guard !all else {
            playAllSolutions(solutions: allSolutions, startWord: startWord)
            return
        }

        guard let puzzle = Puzzle(str: solution, solutions: allSolutions) else {
            return
        }
        playSingleGame(puzzle: puzzle, startWord: startWord)
    }

    func playSingleGame(puzzle: Puzzle, startWord _: Word?) {
        let result = play(puzzle: puzzle, startWord: startWord, verbose: verbose)
        if !verbose {
            print()
            print(formatShareableResult(result, puzzleNumber: puzzle.number))
        } else if result.count <= 6 {
            print("Solved in \(result.count) \(result.count == 1 ? "turn" : "turns.")")
        } else {
            print("Failed to solve Wordle in 6 turns.")
        }
    }

    func playAllSolutions(solutions: [Word], startWord _: Word?) {
        var totalTurns = 0
        var unsolved = 0
        for puzzleNumber in 1 ... solutions.count {
            guard let puzzle = Puzzle(number: puzzleNumber, solutions: solutions) else {
                fatalError("Invalid puzzle number")
            }
            let turns = play(puzzle: puzzle, startWord: startWord, verbose: false).count
            totalTurns += turns
            if turns > 6 {
                unsolved += 1
            }
            print("Wordle #\(puzzle.number) '\(String(puzzle.solution))' took \(turns) turns.")
        }
        let average = Double(totalTurns) / Double(solutions.count)
        print(String(format: "It took an average of %.1f turns to solve all Wordles.", average))
        print("\(unsolved) puzzles were not solved.")
    }

    func readSolutions() -> [Word] {
        if wardle {
            print("Using original Wordle solutions.")
        }
        let filename = wardle ? "Resources/wordle-list-original.txt" : "Resources/wordle-list-nyt.txt"
        do {
            return try String(contentsOfFile: filename, encoding: .utf8)
                .components(separatedBy: .newlines)
                .map(word(_:))
        } catch {
            fatalError("Unable to read word list: '\(filename)'.\n\(error)")
        }
    }
}

SolveWordle.main()
