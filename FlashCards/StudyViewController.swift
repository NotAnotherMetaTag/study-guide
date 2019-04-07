//
//  StudyViewController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//

import UIKit

class StudyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = bgColor
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        let fc1: FlashCard = recognizer.view as! FlashCard
        fc1.flipCard()
    }
}
