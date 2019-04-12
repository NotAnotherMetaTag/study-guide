//
//  CreateEditViewController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//

import UIKit

class CreateEditViewController: UIViewController {
    private var instructionLabel: UILabel = UILabel()
    private let backButton: UIButton = UIButton()
    private let saveButton: UIButton = UIButton()
    private let deleteButton: UIButton = UIButton()
    private var buttonContainer: UIView = UIView()
    private let frameHeight: CGFloat = 50.0
    
    private let cardWidth: CGFloat
    private let cardHeight: CGFloat
    private var cardFrame: CGRect
    private var card: FlashCard
    
    private var originalQuestion: String
    private var originalAnswer: String
    
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
        
        instructionLabel = UILabel(frame: CGRect(x: view.frame.width * 0.12, y: 40, width: view.frame.width * 0.75, height: view.frame.height * 0.25))
        instructionLabel.text = "Tap flashcard to flip it.\nSwipe it to change text."
        instructionLabel.textColor = UIColor.black
        instructionLabel.font = UIFont(name: "papyrus", size: 40)
        //scale down font size to fit frame
        instructionLabel.textAlignment = NSTextAlignment.center
        instructionLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        instructionLabel.minimumScaleFactor = 0.001 //how small the font can be reduced
        instructionLabel.adjustsFontSizeToFitWidth = true
        instructionLabel.numberOfLines = 2
        
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
        
        self.view.addSubview(instructionLabel)
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
    
    //on tap, flip card
    @objc func newCardHandleTap(_ recognizer: UITapGestureRecognizer) {
        card.flipCard()
    }
    
    //on swipe, edit text on this side of card
    @objc func handleSwipe(_ recognizer: UITapGestureRecognizer) {
        //if showing question side of card
        if(card.showingFront == true) {
            getQ()
        } else {
            getA()
        }
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
