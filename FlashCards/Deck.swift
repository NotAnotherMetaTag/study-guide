//
//  Deck.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 4/6/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//
//  Description:  The deck is a saveable object to contain
//                all of our FlashCard.  This class contains
//                some utility methods to simplify deck access.
//

import UIKit

class Deck: NSObject, NSCoding {
    // used in save/load
    private let TNCARDS: String = "Card Array"
    
    private var cards: [FlashCard] = [FlashCard]()
    var count: Int
    
    override init() {
        count = 0
        super.init()
    }
    
    // load init
    required init?(coder aDecoder: NSCoder) {
        cards = aDecoder.decodeObject(forKey: TNCARDS) as! [FlashCard]
        count = cards.count
    }
    
    // save func
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
    
    // removes provided instance of FlashCard from deck if it exists
    func removeCard(fc: FlashCard) {
        if let i = cards.index(of: fc) {
            cards.remove(at: i)
            count = cards.count
        }
    }
    
    // check if card is in deck, used to see if card creator
    // is working on a new card or editing an existing card
    func isCardInDeck(fc: FlashCard) -> Bool{
        if cards.contains(fc) {
            return true
        }
        return false
    }
    
    func setAllCardsShowingFront() {
        for c in cards {
            if c.showingFront == false {
                c.flipCard()
            }
        }
    }
    
}
