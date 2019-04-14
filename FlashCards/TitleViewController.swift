//
//  TitleViewController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//
//  Description:  Title screen view.  Initializes our 
//                global variables that need to be shared
//                throughout the app and provides some
//                navigational elements.
//

import UIKit

// used in setting the background color of the main views, based off of the color
// that was used in the button images RGB(8.5/82.7/90.3)
let bgColor = UIColor(red: 0.085, green: 0.527, blue: 0.903, alpha: 1)

// create a new deck incase load fails
var deck: Deck = Deck()
// initialize our file manager for save/load
let fileController = FileController()

class TitleViewController: UIViewController {
    
    private var myCardsButton: UIButton = UIButton()
    private var studyButton: UIButton = UIButton()
    private var titleImage: UIImageView = UIImageView()
    
    //offset and sizing info
    private let horizontalCenter: CGFloat = UIScreen.main.bounds.size.width / 2
    private let verticleOffset: CGFloat = UIScreen.main.bounds.size.height * 0.40
    
    private let imageHeight: CGFloat = 450
    private let imageWidth: CGFloat = 400
    
    private let buttonVerticleOffset: CGFloat = UIScreen.main.bounds.size.height * 0.75
    private let buttonHeight: CGFloat = 88
    private let buttonWidth: CGFloat = 184
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup display
        titleImage = UIImageView(frame: CGRect(x: horizontalCenter - (imageWidth / 2), y: verticleOffset - (imageHeight / 2), width: imageWidth, height: imageHeight))
        titleImage.image = UIImage(named: "title")
        
        // button to take us to AllCardsView
        myCardsButton = UIButton(type: UIButton.ButtonType.custom)
        myCardsButton.frame = CGRect(x: horizontalCenter - (buttonWidth / 2), y: buttonVerticleOffset - (buttonHeight / 2), width: buttonWidth, height: buttonHeight)
        myCardsButton.setImage(UIImage(named: "myCards"), for: UIControl.State.normal)
        myCardsButton.isEnabled = true
        
        // button to take us to StudyView
        studyButton = UIButton(type: UIButton.ButtonType.custom)
        studyButton.frame = CGRect(x: horizontalCenter - (buttonWidth / 2), y: buttonVerticleOffset - (buttonHeight / 2) + buttonHeight + 5, width: buttonWidth, height: buttonHeight)
        studyButton.setImage(UIImage(named: "studyButton"), for: UIControl.State.normal)
        studyButton.isEnabled = true
        
        self.view.backgroundColor = bgColor
        self.view.addSubview(titleImage)
        self.view.addSubview(myCardsButton)
        self.view.addSubview(studyButton)
        
        // add targets to buttons
        myCardsButton.addTarget(self, action: #selector(TitleViewController.myCardsPressed), for: UIControl.Event.touchUpInside)
        
        studyButton.addTarget(self, action: #selector(TitleViewController.studyPressed), for: UIControl.Event.touchUpInside)
        
        //try to load the deck
        fileController.loadDeck()

    }// end viewDidLoad
    
    // present AllCardsView
    @objc func myCardsPressed() {
        self.present(AllCardsViewController(), animated: true, completion: {() -> Void in
            print("All cards view controller presented...")
        })
    }
    
    // present StudyView if deck is not empty, else alert and go to CreateEditView
    @objc func studyPressed() {
        
        if deck.count > 0 {
            self.present(StudyViewController(), animated: true, completion: {() -> Void in
                print("Study view controller presented...")
            })
        }
        else {
            let alert: UIAlertController = UIAlertController(title: "You have no flashcards!", message: "Time to make one!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                // presents the view while giving it a new default FlashCard object
                self.present(CreateEditViewController(fc: FlashCard())!, animated: true, completion: {() -> Void in
                    print("Create edit view controller presented...")
                })
            }))
            self.present(alert, animated: false, completion: {() -> Void in
                // all done
            })
        }
    }
    
}
