// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

import Foundation

public struct Puzzle {
    /// Solutions for all puzzles in number order.
    public let solutions: [Word]

    /// The number for this puzzle between 1 ... solutions.count.
    public let number: Int

    /// The solution for this puzzle.
    public var solution: Word {
        solutions[number - 1]
    }

    public init?(number: Int, solutions: [Word]) {
        self.solutions = solutions
        guard 1 ... solutions.count ~= number else {
            print("Sorry, \(number) is not a valid puzzle number.")
            return nil
        }
        self.number = number
    }

    public init?(solution: Word, solutions: [Word]) {
        self.solutions = solutions
        guard let solutionNumber = solutions.firstIndex(of: solution) else {
            print("Sorry, '\(String(solution))' is not a valid Wordle solution.")
            return nil
        }
        number = solutionNumber + 1
    }

    public init?(str: String?, solutions: [Word]) {
        guard let str = str else {
            // No solution provided, pick one at random.
            let solutionNumber = Int.random(in: 1 ... solutions.count)
            self.init(number: solutionNumber, solutions: solutions)
            return
        }
        if let solutionNumber = Int(str) {
            self.init(number: solutionNumber, solutions: solutions)
        } else {
            let solutionWord = word(str)
            self.init(solution: solutionWord, solutions: solutions)
        }
    }
}
