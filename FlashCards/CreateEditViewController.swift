//
//  CreateEditViewController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//

import UIKit

class CreateEditViewController: UIViewController {
    let backButton: UIButton = UIButton()
    let saveButton: UIButton = UIButton()
    let deleteButton: UIButton = UIButton()
    let cardWidth: CGFloat = UIScreen.main.bounds.size.width * 0.75
    let cardHeight: CGFloat
    
    var cardFrame: CGRect
    
    var card: FlashCard
    
    init?(fc: FlashCard) {
        card = fc
        cardHeight  = cardWidth * 0.6
        cardFrame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - (cardWidth / 2), y:  (UIScreen.main.bounds.size.height / 2) - (cardHeight / 2), width: cardWidth, height: cardHeight)
        card.setFrame(f: cardFrame)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //needs buttons and other functionality
        
        self.view.addSubview(card)
        self.view.backgroundColor = bgColor
    }
    
    
}
