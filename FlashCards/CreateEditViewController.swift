//
//  CreateEditViewController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//
//  Description:  Used to create/edit flashcards for the deck.
//                Needs to be initialized with a flashcard which
//                may or may not exist in the deck (new cards).
//                Tapping a card flips it, swiping in any direction
//                edits the text on that side of the card. Cards
//                may be deleted here, or you can back out of the
//                view without making changes.
//

import UIKit

class CreateEditViewController: UIViewController {
    // provides gesture information to users
    private var instructionLabel: UILabel = UILabel()
    
    // buttons
    private var backButton: UIButton = UIButton()
    private var saveButton: UIButton = UIButton()
    private var deleteButton: UIButton = UIButton()
    
    // overlays the flashcard and handles taps/swipe
    // gestures so we don't have to add them to the card
    // directly
    private var cardHitBox: UIView = UIView()
    
    // sizing info
    private let frameHeight: CGFloat = 50.0
    private let cardWidth: CGFloat
    private let cardHeight: CGFloat
    private var cardFrame: CGRect
    
    private var card: FlashCard
    
    // holds our original text incase user backs out
    private var originalQuestion: String
    private var originalAnswer: String
    
    init?(fc: FlashCard) {
        card = fc
        cardWidth = UIScreen.main.bounds.size.width * 0.75
        cardHeight  = cardWidth * 0.6
        cardFrame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - (cardWidth / 2), y:  (UIScreen.main.bounds.size.height / 2) - (cardHeight / 2), width: cardWidth, height: cardHeight)
        
        // update the card's frame and it's label's frame
        card.setFrame(f: cardFrame)
        
        cardHitBox = UIView(frame: cardFrame)
        
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
        // scale down font size to fit frame
        instructionLabel.textAlignment = NSTextAlignment.center
        instructionLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        instructionLabel.minimumScaleFactor = 0.001 //how small the font can be reduced
        instructionLabel.adjustsFontSizeToFitWidth = true
        instructionLabel.numberOfLines = 2
        
        // more sizing
        let buttonWidth = view.frame.width * 0.22
        
        // tap gesture to flip card
        cardHitBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateEditViewController.newCardHandleTap(_:))))
        
        // back button -> cancel editing or making new card, go back a view.
        backButton = UIButton(frame: CGRect(x: (view.frame.width * 0.25) - (buttonWidth / 2), y: view.frame.height * 0.7, width: buttonWidth, height: frameHeight))
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.isUserInteractionEnabled = true
        
        backButton.addTarget(self, action: #selector(CreateEditViewController.backButtonPressed), for: UIControl.Event.touchUpInside)
        
        // save button -> save a new card or complete updating.
        saveButton = UIButton(frame: CGRect(x: (view.frame.width * 0.5) - (buttonWidth / 2), y: view.frame.height * 0.7, width: buttonWidth, height: frameHeight))
        saveButton.setImage(UIImage(named: "saveButton"), for: .normal)
        saveButton.isUserInteractionEnabled = true
        
        saveButton.addTarget(self, action: #selector(CreateEditViewController.saveButtonPressed), for: UIControl.Event.touchUpInside)
        
        // delete button -> remove card from deck or discard if new card.
        deleteButton = UIButton(frame: CGRect(x: (view.frame.width * 0.75) - (buttonWidth / 2), y: view.frame.height * 0.7, width: view.frame.width * 0.22, height: frameHeight))
        deleteButton.setImage(UIImage(named: "deleteButton"), for: .normal)
        deleteButton.isUserInteractionEnabled = true
        
        deleteButton.addTarget(self, action: #selector(CreateEditViewController.deleteButtonPressed), for: UIControl.Event.touchUpInside)
        
        // swipe card any direction to edit text for that side
        let swipeU: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CreateEditViewController.handleSwipe(_:)))
        swipeU.direction = UISwipeGestureRecognizer.Direction.up
        cardHitBox.addGestureRecognizer(swipeU)
        let swipeD: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CreateEditViewController.handleSwipe(_:)))
        swipeD.direction = UISwipeGestureRecognizer.Direction.down
        cardHitBox.addGestureRecognizer(swipeD)
        let swipeL: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CreateEditViewController.handleSwipe(_:)))
        swipeL.direction = UISwipeGestureRecognizer.Direction.left
        cardHitBox.addGestureRecognizer(swipeL)
        let swipeR: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CreateEditViewController.handleSwipe(_:)))
        swipeR.direction = UISwipeGestureRecognizer.Direction.right
        cardHitBox.addGestureRecognizer(swipeR)
        
        self.view.addSubview(instructionLabel)
        self.view.addSubview(card)
        self.view.addSubview(cardHitBox)
        self.view.addSubview(backButton)
        self.view.addSubview(saveButton)
        self.view.addSubview(deleteButton)
        self.view.backgroundColor = bgColor
        
    }
    
    // on tap, flip card
    @objc func newCardHandleTap(_ recognizer: UITapGestureRecognizer) {
        card.flipCard()
    }
    
    // on swipe, edit text on this side of card
    @objc func handleSwipe(_ recognizer: UITapGestureRecognizer) {
        // if showing question side of card
        if(card.showingFront == true) {
            let alert: UIAlertController = UIAlertController(title: "Set Question", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                // do nothing
            }))
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                self.card.label.text = (alert.textFields?[0].text)!
                self.card.qText = (alert.textFields?[0].text)!
            }))
            alert.addTextField(configurationHandler: {(t: UITextField) -> Void in
                t.placeholder = "Question"
            })
            self.present(alert, animated: false, completion: {() -> Void in
                // all done
            })
        } else { // showing answer side of card
            let alert: UIAlertController = UIAlertController(title: "Set Answer", message: ":", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                // do nothing
            }))
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
                self.card.label.text = (alert.textFields?[0].text)!
                self.card.aText = (alert.textFields?[0].text)!
            }))
            alert.addTextField(configurationHandler: {(t: UITextField) -> Void in
                t.placeholder = "Answer"
            })
            self.present(alert, animated: false, completion: {() -> Void in
                // all done
            })
        }
    }
    
    // When pressed, discard information and go back to AllCards view.
    @objc func backButtonPressed(_ recognizer: UITapGestureRecognizer) {
        //reset info on card
        card.qText = self.originalQuestion
        card.aText = self.originalAnswer
        if card.showingFront == true {
            card.label.text = card.qText
        } else {
            card.label.text = card.aText
        }
        // dismiss the view
        self.presentingViewController?.dismiss(animated: false, completion: {
            () -> Void in
            print("Create edit view controller dismissed...")
        })
    }
    
    // When pressed, show alert confirming changes
    @objc func saveButtonPressed(_ recognizer: UITapGestureRecognizer) {
        // add card to deck if it was new
        if deck.isCardInDeck(fc: self.card) == false {
            deck.addCard(newCard: self.card)
        }
        // save the deck
        fileController.saveDeck()
        
        // dismiss the view
        self.presentingViewController?.dismiss(animated: true, completion: {
            () -> Void in
            print("Create edit view controller dismissed...")
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
            // dismiss the view
            self.presentingViewController?.dismiss(animated: true, completion: {
                () -> Void in
                print("Create edit view controller dismissed...")
            })
        }))
        self.present(alert, animated: false, completion: {() -> Void in
            // all done
        })

    }
    
}
