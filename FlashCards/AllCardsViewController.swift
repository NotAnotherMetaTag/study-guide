//
//  AllCardsViewController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//

import UIKit

class AllCardsViewController: UIViewController {
    
    private var newButton: UIButton = UIButton()
    
    //offset and sizing info
    private let horizontalCenter: CGFloat = UIScreen.main.bounds.size.width / 2
    private let verticleOffset: CGFloat = UIScreen.main.bounds.size.height * 0.33
    private let cardHeight: CGFloat = 100
    private let cardWidth: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //offset and sizing info
        let cardFrame: CGRect = CGRect(x: horizontalCenter - (cardWidth / 2), y: verticleOffset, width: cardWidth, height: cardHeight)
        
        //setup display
        
        
        //testing flash card
        let fc: FlashCard = FlashCard(frame: cardFrame)
        fc.isUserInteractionEnabled = true
        
        self.view.backgroundColor = bgColor
        self.view.addSubview(fc)
        
        fc.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AllCardsViewController.handleTap(_:))))
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        let fc1: FlashCard = recognizer.view as! FlashCard
        print("tap?")
        fc1.flipCard()
    }
    
    
}
