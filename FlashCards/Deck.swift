//
//  Deck.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 4/6/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//

import UIKit

class Deck: NSObject, NSCoding {
    private let TNCARDS: String = "Card Array"
    
    private var cards: [FlashCard] = [FlashCard]()
    var count: Int
    
    override init() {
        count = 0
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        cards = aDecoder.decodeObject(forKey: TNCARDS) as! [FlashCard]
        count = cards.count
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cards, forKey: TNCARDS)
    }
    
    func addCard(newCard: FlashCard) {
        cards.append(newCard)
        count = cards.count
    }
    
    func getCardAtIndex(index: Int) -> FlashCard {
        return cards[index]
    }
    
    func removeCard(fc: FlashCard) {
        if let i = cards.index(of: fc) {
            cards.remove(at: i)
            count = cards.count
        }
    }
    
}
