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
    var buttonContainer: UIView = UIView()
    let frameHeight: CGFloat = 50.0
    
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var cardFrame: CGRect
    
    var card: FlashCard
    
    var originalQuestion: String
    var originalAnswer: String
    
    init?(fc: FlashCard) {
        card = fc
        cardWidth = UIScreen.main.bounds.size.width * 0.75
        cardHeight  = cardWidth * 0.6
        cardFrame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - (cardWidth / 2), y:  (UIScreen.main.bounds.size.height / 2) - (cardHeight / 2), width: cardWidth, height: cardHeight)
        card.setFrame(f: cardFrame)
        
        buttonContainer = UIView(frame: cardFrame)
        
        originalQuestion = card.qText
        originalAnswer = card.aText

        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //needs buttons and other functionality
        
        //create button
        buttonContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateEditViewController.newCardHandleTap(_:))))
        
        //back button
        //back button -> cancel editing or making new card, go back a view.
        let backButton: UIButton = UIButton(frame: CGRect(x: view.frame.width * 0.25, y: view.frame.height * 0.7, width: view.frame.width * 0.22, height: frameHeight))
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.isUserInteractionEnabled = true
        
        backButton.addTarget(self, action: #selector(CreateEditViewController.backButtonPressed), for: UIControl.Event.touchUpInside)
        
        //save button -> save a new card or complete updating.
        let saveButton: UIButton = UIButton(frame: CGRect(x: view.frame.width * 0.5, y: view.frame.height * 0.7, width: view.frame.width * 0.22, height: frameHeight))
        saveButton.setImage(UIImage(named: "saveButton"), for: .normal)
        saveButton.isUserInteractionEnabled = true
        
        backButton.addTarget(self, action: #selector(CreateEditViewController.backButtonPressed), for: UIControl.Event.touchUpInside)
        saveButton.addTarget(self, action: #selector(CreateEditViewController.saveButtonPressed), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(card)
        self.view.addSubview(buttonContainer)
        self.view.addSubview(backButton)
        self.view.addSubview(saveButton)
        self.view.backgroundColor = bgColor
        
    }
    
    //On tap of card, pop up keyboard & enable edit of label text
    @objc func newCardHandleTap(_ recognizer: UITapGestureRecognizer) {
        //if showing question side of card
        if(card.showingFront == true) {
        let alert: UIAlertController = UIAlertController(title: "Set Question", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            self.card.label.text = (alert.textFields?[0].text)!
        }))
        alert.addTextField(configurationHandler: {(t: UITextField) -> Void in
            t.placeholder = "Question"
        })
            self.present(alert, animated: false, completion: {() -> Void in
                //TODO: save state of card
            })
    }
        //showing answer side of card
        if(card.showingFront == false) {
            let alert: UIAlertController = UIAlertController(title: "Set Answer", message: ":", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                self.card.label.text = (alert.textFields?[0].text)!
            }))
            alert.addTextField(configurationHandler: {(t: UITextField) -> Void in
                t.placeholder = "Answer"
            })
            self.present(alert, animated: false, completion: {() -> Void in
                //TODO: save state of card
            })
        }
    }
    
    //When pressed, discard information and go back to AllCards view.
    @objc func backButtonPressed(_ recognizer: UITapGestureRecognizer) {
            self.presentingViewController?.dismiss(animated: false, completion: {
                () -> Void in
                //reset info on card
                self.card.qText = self.originalQuestion
                self.card.aText = self.originalAnswer
            })
    }
    
    //When pressed, show alert confirming changes
    @objc func saveButtonPressed(_ recognizer: UITapGestureRecognizer) {
           self.presentingViewController?.dismiss(animated: true, completion: {
                () -> Void in
            //TODO: Ensure info is saved
            })
    }
}
