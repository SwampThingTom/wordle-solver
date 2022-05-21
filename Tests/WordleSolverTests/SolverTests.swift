// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

@testable import WordleSolver
import XCTest

final class SolverTests: XCTestCase {
    func testClue_noMatch() throws {
        let expected = Array(repeating: LetterClue.notInWord, count: 5)
        let clue = Solver(solution: word("BROAD")).clue(for: word("CLIME"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_correct() throws {
        let expected = Array(repeating: LetterClue.inPosition, count: 5)
        let clue = Solver(solution: word("BROAD")).clue(for: word("BROAD"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_anagram() throws {
        let expected = Array(repeating: LetterClue.inWord, count: 5)
        let clue = Solver(solution: word("BROAD")).clue(for: word("DOBRA"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_mix() throws {
        let expected: Clue = [.inPosition, .inWord, .notInWord, .inWord, .notInWord]
        let clue = Solver(solution: word("BROAD")).clue(for: word("BONDS"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_inWord_start() throws {
        let expected: Clue = [.inWord, .notInWord, .notInWord, .notInWord, .notInWord]
        let clue = Solver(solution: word("BROAD")).clue(for: word("APTLY"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_inWord_end() throws {
        let expected: Clue = [.notInWord, .notInWord, .notInWord, .notInWord, .inWord]
        let clue = Solver(solution: word("BROAD")).clue(for: word("LINGO"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_inPosition_start() throws {
        let expected: Clue = [.inPosition, .notInWord, .notInWord, .notInWord, .notInWord]
        let clue = Solver(solution: word("BROAD")).clue(for: word("BENCH"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_inPosition_end() throws {
        let expected: Clue = [.notInWord, .notInWord, .notInWord, .notInWord, .inPosition]
        let clue = Solver(solution: word("BROAD")).clue(for: word("SQUID"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_doubleLetter_inPosition_guess() throws {
        let expected: Clue = [.inPosition, .notInWord, .inPosition, .notInWord, .notInWord]
        let clue = Solver(solution: word("BROAD")).clue(for: word("BOOBS"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_doubleLetter_inWord_guess() throws {
        let expected: Clue = [.inWord, .notInWord, .notInWord, .notInWord, .notInWord]
        let clue = Solver(solution: word("BROAD")).clue(for: word("OUTGO"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_doubleLetter_inPosition_solution() throws {
        let expected: Clue = [.notInWord, .notInWord, .notInWord, .inWord, .inPosition]
        let clue = Solver(solution: word("STILT")).clue(for: word("CHEST"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_doubleLetter_inWord_solution() throws {
        let expected: Clue = [.inWord, .notInWord, .notInWord, .notInWord, .notInWord]
        let clue = Solver(solution: word("STILT")).clue(for: word("TUDOR"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_doubleLetter_inPosition_clue_solution() throws {
        let expected: Clue = [.inPosition, .notInWord, .inPosition, .notInWord, .inPosition]
        let clue = Solver(solution: word("TWEET")).clue(for: word("TREAT"))
        XCTAssertEqual(clue, expected)
    }

    func testClue_doubleLetter_inWord_clue_solution() throws {
        let expected: Clue = [.notInWord, .notInWord, .inWord, .inWord, .notInWord]
        let clue = Solver(solution: word("TWEET")).clue(for: word("DITTY"))
        XCTAssertEqual(clue, expected)
    }

    func testWordsMatching_clueNoMatch() throws {
        let expected = [
            word("KLUTZ"), word("WITTY"), word("GUILD"), word("PULPY"), word("STOOD"),
        ]
        let possibleWords = [
            word("KLUTZ"), word("AGONY"), word("THICK"), word("TASTE"), word("WITTY"),
            word("SHORT"), word("ARISE"), word("GUILD"), word("MINOR"), word("CLASS"),
            word("AMBER"), word("PULPY"), word("WRIST"), word("PLANT"), word("STOOD"),
        ]
        let guess = word("CREAM")
        let clue = Array(repeating: LetterClue.notInWord, count: 5)
        let matches = Solver(solution: word("GUILD")).wordsMatching(clue: clue, for: guess, in: possibleWords)
        XCTAssertEqual(matches, expected)
    }

    func testWordsMatching_clueAnagram() throws {
        let expected = [
            word("RATES"), word("TARES"),
        ]
        let possibleWords = [
            word("KLUTZ"), word("AGONY"), word("THICK"), word("TEARS"), word("WITTY"),
            word("SHORT"), word("RATES"), word("TARES"), word("MINOR"), word("CLASS"),
            word("AMBER"), word("PULPY"), word("WRIST"), word("PLANT"), word("STARE"),
        ]
        let guess = word("STARE")
        let clue = Array(repeating: LetterClue.inWord, count: 5)
        let matches = Solver(solution: word("RATES")).wordsMatching(clue: clue, for: guess, in: possibleWords)
        XCTAssertEqual(matches, expected)
    }

    func testWordsMatching_clueMatch() throws {
        let expected = [word("STARE")]
        let possibleWords = [
            word("KLUTZ"), word("AGONY"), word("THICK"), word("TEARS"), word("WITTY"),
            word("SHORT"), word("RATES"), word("TARES"), word("MINOR"), word("CLASS"),
            word("AMBER"), word("PULPY"), word("WRIST"), word("PLANT"), word("STARE"),
        ]
        let guess = word("STARE")
        let clue = Array(repeating: LetterClue.inPosition, count: 5)
        let matches = Solver(solution: word("STARE")).wordsMatching(clue: clue, for: guess, in: possibleWords)
        XCTAssertEqual(matches, expected)
    }
}
