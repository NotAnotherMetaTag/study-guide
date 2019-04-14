//
//  FlashCard.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//
//  Description:  A saveable extention of UIImageView that
//                has a built in label, front and back text
//                strings and utility methods to help present
//                and animate the FlashCard.
//

import UIKit

class FlashCard: UIImageView {
    // used in save/load
    private let TNQUESTION: String = "Question Text"
    private let TNANSWER: String = "Answer Text"
    
    // they all use the same image
    let cardImage: UIImage? = UIImage(named: "index-card")
    
    var label: UILabel = UILabel()
    var qText: String = ""
    var aText: String = ""
    
    // front is the question side
    var showingFront: Bool = true
    
    init() {
        super.init(image: cardImage)
        // default frame, each view should change this using our setFrame method to fit the given view
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        
        // default text for card creation
        qText = "Q:"
        aText = "A:"
        
        // default label frame, again this will be updated within setFrame in each view
        label.frame = CGRect(x: 10, y: 10, width: self.frame.width - 20, height: self.frame.height - 20)
        label.text = qText
        label.font = UIFont(name: "papyrus", size: 30)
        
        // scale down font size to fit frame
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.minimumScaleFactor = 0.001 //how small the font can be reduced
        label.numberOfLines = 8 //max number of lines for wrapping
        label.adjustsFontSizeToFitWidth = true
        
        self.addSubview(label)
    }
    
    // loading card init, only the q/a text was saved so everything else is initialized like the above init
    required init?(coder aDecoder: NSCoder) {
        super.init(image: cardImage)
        qText = aDecoder.decodeObject(forKey: TNQUESTION) as? String ?? "Q:"
        aText = aDecoder.decodeObject(forKey: TNANSWER) as? String ?? "A:"
        
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        label.frame = CGRect(x: 10, y: 10, width: self.frame.width - 20, height: self.frame.height - 20)
        label.text = qText
        label.font = UIFont(name: "papyrus", size: 30)
        
        // scale down font size to fit frame
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.minimumScaleFactor = 0.001 //how small the font can be reduced
        label.numberOfLines = 8 //max number of lines for wrapping
        label.adjustsFontSizeToFitWidth = true
        
        self.addSubview(label)
    }
    
    // save card func
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(qText, forKey: TNQUESTION)
        aCoder.encode(aText, forKey: TNANSWER)
    }
    
    // updates frame and label frame based on it
    // each view should call this on all cards passing in the frame size/position desired
    func setFrame(f : CGRect) {
        self.frame = f
        // scales label frame to be slightly smaller than card frame and centered
        label.frame = CGRect(x: 10, y: 10, width: self.frame.width - 20, height: self.frame.height - 20)
    }
    
    // animates the card flip and updates label and showingFront
    func flipCard() {
        UIView.transition(with: self, duration: 1, options: UIView.AnimationOptions.transitionFlipFromRight, animations: { () -> Void in
            self.showingFront = !self.showingFront
            if(self.showingFront) {
                self.label.text = self.qText
            }
            else {
                self.label.text = self.aText
            }
        }, completion: nil)
    }
    
}
