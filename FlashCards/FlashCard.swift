//
//  FlashCard.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//

import UIKit

class FlashCard: UIImageView {
    private let TNQUESTION: String = "Question Text"
    private let TNANSWER: String = "Answer Text"
    
    let cardImage: UIImage? = UIImage(named: "index-card")
    
    var label: UILabel = UILabel()
    var qText: String = ""
    var aText: String = ""
    
    var showingFront: Bool = true
    
    init() {
        super.init(image: cardImage)
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        qText = "Q:"
        aText = "A:"
        label.frame = CGRect(x: 10, y: 10, width: self.frame.width - 20, height: self.frame.height - 20)
        label.text = qText
        label.font = UIFont(name: "papyrus", size: 30)
        
        //scale down font size to fit frame
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.minimumScaleFactor = 0.001 //how small the font can be reduced
        label.numberOfLines = 8 //max number of lines for wrapping
        label.adjustsFontSizeToFitWidth = true
        
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(image: cardImage)
        qText = aDecoder.decodeObject(forKey: TNQUESTION) as? String ?? "Q:"
        aText = aDecoder.decodeObject(forKey: TNANSWER) as? String ?? "A:"
        
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        label.frame = CGRect(x: 10, y: 10, width: self.frame.width - 20, height: self.frame.height - 20)
        label.text = qText
        label.font = UIFont(name: "papyrus", size: 30)
        
        //scale down font size to fit frame
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.minimumScaleFactor = 0.001 //how small the font can be reduced
        label.numberOfLines = 8 //max number of lines for wrapping
        label.adjustsFontSizeToFitWidth = true
        
        self.addSubview(label)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(qText, forKey: TNQUESTION)
        aCoder.encode(aText, forKey: TNANSWER)
    }
    
    //updates frame and label frame based on it
    func setFrame(f : CGRect) {
        self.frame = f
        label.frame = CGRect(x: 10, y: 10, width: self.frame.width - 20, height: self.frame.height - 20)
    }
    
    func flipCard() {
        //print("flip?")
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
