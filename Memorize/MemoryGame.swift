//
//  MemoryGame.swift
//  Memorize
//
//  Created by William on 11/15/20.
//

import Foundation

// <CardContent> here is to declare to the world that I'm a generic type
// MemoryGame only works when CardContent implement Equatable
struct MemoryGame<CardContent> where CardContent: Equatable {
    // private(set) means setting this is private, but reading this is not
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
//            var faceUpCardIndices = [Int]()
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    faceUpCardIndices.append(index)
//                }
//            }
//            if faceUpCardIndices.count == 1 {
//                return faceUpCardIndices.first
//            } else {
//                return nil
//            }
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        // comma is a sequential AND here, check the condition sequentially, AND them
        // only choose the card that are unfaceup and unmatched
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            // when there is only one card face up, and you're ready to click another card, then you need to check if these two cards are matched
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                // since CardContent implement Equatable, can use == function here
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                // no matter matched or not, there are two cards face-up now
//                indexOfTheOneAndOnlyFaceUpCard = nil
                self.cards[chosenIndex].isFaceUp = true
            } else {
                // there is either zero or more than one cards face-up, turn all the cards face-down
//                for index in cards.indices {
//                    cards[index].isFaceUp = false
//                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
//    func index(of card: Card) -> Int {
//        for index in 0..<self.cards.count {
//            if self.cards[index].id == card.id {
//                return index
//            }
//        }
//        return 0 // TODO: bogus!
//    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    // Identifiable is a protocol, gain ability to be identified
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        // CardContent is my made-up(don't care) type, a generic type, CardContent can be determined either Int, String, Image, etc.
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
