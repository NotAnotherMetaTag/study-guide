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
        
        let buttonWidth = view.frame.width * 0.22
        
        //create button
        buttonContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateEditViewController.newCardHandleTap(_:))))
        
        //back button
        //back button -> cancel editing or making new card, go back a view.
        let backButton: UIButton = UIButton(frame: CGRect(x: (view.frame.width * 0.25) - (buttonWidth / 2), y: view.frame.height * 0.7, width: buttonWidth, height: frameHeight))
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.isUserInteractionEnabled = true
        
        backButton.addTarget(self, action: #selector(CreateEditViewController.backButtonPressed), for: UIControl.Event.touchUpInside)
        
        //save button -> save a new card or complete updating.
        let saveButton: UIButton = UIButton(frame: CGRect(x: (view.frame.width * 0.5) - (buttonWidth / 2), y: view.frame.height * 0.7, width: buttonWidth, height: frameHeight))
        saveButton.setImage(UIImage(named: "saveButton"), for: .normal)
        saveButton.isUserInteractionEnabled = true
        
        saveButton.addTarget(self, action: #selector(CreateEditViewController.saveButtonPressed), for: UIControl.Event.touchUpInside)
        
        let deleteButton: UIButton = UIButton(frame: CGRect(x: (view.frame.width * 0.75) - (buttonWidth / 2), y: view.frame.height * 0.7, width: view.frame.width * 0.22, height: frameHeight))
        deleteButton.setImage(UIImage(named: "deleteButton"), for: .normal)
        deleteButton.isUserInteractionEnabled = true
        
        deleteButton.addTarget(self, action: #selector(CreateEditViewController.deleteButtonPressed), for: UIControl.Event.touchUpInside)
        
        //swipe card any direction to flip
        let swipeU: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CreateEditViewController.handleSwipe(_:)))
        swipeU.direction = UISwipeGestureRecognizer.Direction.up
        buttonContainer.addGestureRecognizer(swipeU)
        let swipeD: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CreateEditViewController.handleSwipe(_:)))
        swipeD.direction = UISwipeGestureRecognizer.Direction.down
        buttonContainer.addGestureRecognizer(swipeD)
        let swipeL: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CreateEditViewController.handleSwipe(_:)))
        swipeL.direction = UISwipeGestureRecognizer.Direction.left
        buttonContainer.addGestureRecognizer(swipeL)
        let swipeR: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CreateEditViewController.handleSwipe(_:)))
        swipeR.direction = UISwipeGestureRecognizer.Direction.right
        buttonContainer.addGestureRecognizer(swipeR)
        
        self.view.addSubview(card)
        self.view.addSubview(buttonContainer)
        self.view.addSubview(backButton)
        self.view.addSubview(saveButton)
        self.view.addSubview(deleteButton)
        self.view.backgroundColor = bgColor
        
    }
    
    private func getQ() {
        let alert: UIAlertController = UIAlertController(title: "Set Question", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            self.card.label.text = (alert.textFields?[0].text)!
            self.card.qText = (alert.textFields?[0].text)!
        }))
        alert.addTextField(configurationHandler: {(t: UITextField) -> Void in
            t.placeholder = "Question"
        })
        self.present(alert, animated: false, completion: {() -> Void in
            
        })
    }
    
    private func getA() {
        let alert: UIAlertController = UIAlertController(title: "Set Answer", message: ":", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            self.card.label.text = (alert.textFields?[0].text)!
            self.card.aText = (alert.textFields?[0].text)!
        }))
        alert.addTextField(configurationHandler: {(t: UITextField) -> Void in
            t.placeholder = "Answer"
        })
        self.present(alert, animated: false, completion: {() -> Void in
            
        })
    }
    
    //On tap of card, pop up keyboard & enable edit of label text
    @objc func newCardHandleTap(_ recognizer: UITapGestureRecognizer) {
        //if showing question side of card
        if(card.showingFront == true) {
            getQ()
        } else {
            getA()
        }
        
        //showing answer side of card
        if(card.showingFront == false) {
            getA()
        } else {
            getQ()
        }
    }
    
    @objc func handleSwipe(_ recognizer: UITapGestureRecognizer) {
        card.flipCard()
    }
    
    //When pressed, discard information and go back to AllCards view.
    @objc func backButtonPressed(_ recognizer: UITapGestureRecognizer) {
        //reset info on card
        self.card.qText = self.originalQuestion
        self.card.aText = self.originalAnswer
        self.presentingViewController?.dismiss(animated: false, completion: {
            () -> Void in
        })
    }
    
    //When pressed, show alert confirming changes
    @objc func saveButtonPressed(_ recognizer: UITapGestureRecognizer) {
        //add card to deck if it was new
        if deck.isCardInDeck(fc: self.card) == false {
            deck.addCard(newCard: self.card)
        }
        //save the deck
        fileController.saveDeck()
        
        self.presentingViewController?.dismiss(animated: true, completion: {
            () -> Void in
            //
        })
    }
    
    @objc func deleteButtonPressed(_ recognizer: UITapGestureRecognizer) {
        let alert: UIAlertController = UIAlertController(title: "Are you sure?", message: "Deleted flash cards can not be recovered.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Keep it", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            //do nothing
        }))
        alert.addAction(UIAlertAction(title: "Delete it", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            //only need to make changes if card was saved into deck
            if deck.isCardInDeck(fc: self.card) == true {
                deck.removeCard(fc: self.card)
                //save the deck
                fileController.saveDeck()
            }
            self.presentingViewController?.dismiss(animated: true, completion: {
                () -> Void in
                //
            })
        }))
        self.present(alert, animated: false, completion: {() -> Void in
            
        })

    }
    
}
