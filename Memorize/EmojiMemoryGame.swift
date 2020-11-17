//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by William on 11/15/20.
//

// ViewModel
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    // variable that it can access the Model through
    // @Published is a property wrapper, it means everytime this property model changes, it calls objectWillChange.send()
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()

    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻", "🎃", "👽", "👺"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // var objectWillChange: ObservableObjectPublisher
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s), functions that allow views to access the Model
    func choose(card: MemoryGame<String>.Card) {
        // objectWillChange.send()
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
