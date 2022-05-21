// Copyright © 2022 Thomas H Aylesworth
// Refer to the LICENSE file for the terms that govern licensing and
// distribution of this software.

import Foundation
import WordleSolver

let allWords = [
    "KLUTZ", "AGONY", "THICK", "TASTE", "WITTY",
    "SHORT", "ARISE", "GUILD", "MINOR", "CLASS",
    "AMBER", "PULPY", "WRIST", "PLANT", "STOOD",
].map(word)

play(wordList: allWords, solution: allWords.randomElement()!)
