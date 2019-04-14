//
//  StudyViewController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//
//  Description:  View allows users to swipe left/right through
//                their deck and study their cards. Tapping the
//                card flips it over.  The cards loop from last
//                to first if the beginning/end is reached and
//                there is more than one card.  A deck of size 1
//                can not be swiped through, the card will just
//                wiggle.  Cards always show question when coming
//                into view.
//
//                The deck shouldn't be empty when coming here
//                but this view does check just in case. Currently
//                all other views check before presenting StudyView.
//

import UIKit

class StudyViewController: UIViewController {
    // provides gesture information to users
    private var instructionLabel: UILabel = UILabel()
    
    // updated in viewDidLoad
    private var card: FlashCard = FlashCard()
    private var deckSize: Int = 0
    
    // keeps track of where we are in the deck
    private var currentDeckIndex: Int = 0
    
    // offset and sizing info
    private let horizontalCenter: CGFloat = UIScreen.main.bounds.size.width / 2
    private let verticleCenter: CGFloat = UIScreen.main.bounds.size.height / 2
    
    private var cardWidth: CGFloat = CGFloat()
    private var cardHeight: CGFloat = CGFloat()
    private var cardFrame: CGRect = CGRect()
    
    private var backButton: UIButton = UIButton()
    private let buttonHeight: CGFloat = 66
    private let buttonWidth: CGFloat = 138
    private let buttonVerticleOffset: CGFloat = UIScreen.main.bounds.size.height * 0.75
    
    // overlays the flashcard and handles taps/swipe
    // gestures so we don't have to add them to the card
    // directly
    private var cardHitBox: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check the deck size just in case
        if deck.count <= 0 {
            // dismiss the view
            self.presentingViewController?.dismiss(animated: false, completion: {
                () -> Void in
                print("Study view controller dismissed...")
            })
        }
        
        // deck isn't empty, finish setting up
        card = deck.getCardAtIndex(index: 0)
        deckSize = deck.count
        
        instructionLabel = UILabel(frame: CGRect(x: view.frame.width * 0.12, y: 40, width: view.frame.width * 0.75, height: view.frame.height * 0.25))
        instructionLabel.text = "Tap flashcard to flip it.\nSwipe it to see previous/next."
        instructionLabel.textColor = UIColor.black
        instructionLabel.font = UIFont(name: "papyrus", size: 40)
        // scale down font size to fit frame
        instructionLabel.textAlignment = NSTextAlignment.center
        instructionLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        instructionLabel.minimumScaleFactor = 0.001 //how small the font can be reduced
        instructionLabel.adjustsFontSizeToFitWidth = true
        instructionLabel.numberOfLines = 2
        
        // sizing
        cardWidth = UIScreen.main.bounds.size.width * 0.80
        cardHeight = cardWidth * 0.6
        cardFrame = CGRect(x: horizontalCenter - (cardWidth / 2), y: verticleCenter - (cardHeight / 2), width: cardWidth, height: cardHeight)
        
        // update the card's frame and it's label's frame
        card.setFrame(f: cardFrame)
        
        //make sure everything is showing front
        deck.setAllCardsShowingFront()
        
        // button to dismiss the view
        backButton = UIButton(frame: CGRect(x: horizontalCenter - (buttonWidth / 2), y: buttonVerticleOffset, width: buttonWidth, height: buttonHeight))
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.isUserInteractionEnabled = true
        backButton.addTarget(self, action: #selector(StudyViewController.backButtonPressed), for: UIControl.Event.touchUpInside)
        
        // setup hit box and gestures
        cardHitBox = UIView(frame: cardFrame)
        // flip card
        cardHitBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StudyViewController.handleTap(_:))))
        
        // move to next card
        let swipeL: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(StudyViewController.handleSwipeLeft(_:)))
        swipeL.direction = UISwipeGestureRecognizer.Direction.left
        cardHitBox.addGestureRecognizer(swipeL)
        // move to previous card
        let swipeR: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(StudyViewController.handleSwipeRight(_:)))
        swipeR.direction = UISwipeGestureRecognizer.Direction.right
        cardHitBox.addGestureRecognizer(swipeR)
        
        self.view.backgroundColor = bgColor
        self.view.addSubview(instructionLabel)
        self.view.addSubview(card)
        self.view.addSubview(cardHitBox)
        self.view.addSubview(backButton)
    }
    
    // flip card
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        card.flipCard()
    }
    
    // go to next card
    @objc func handleSwipeLeft(_ recognizer: UITapGestureRecognizer) {
        // more than 1 card, move to next
        if deckSize > 1 {
            var nextIndex = currentDeckIndex + 1
            if nextIndex >= deckSize {
                nextIndex = 0
            }
            let nextCard: FlashCard = deck.getCardAtIndex(index: nextIndex)
            
            // update the card's frame and it's label's frame
            nextCard.setFrame(f: cardFrame)
            nextCard.center.x = UIScreen.main.bounds.size.width + 5 + (cardWidth / 2)
            self.view.addSubview(nextCard)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                () -> Void in
                nextCard.center.x = self.horizontalCenter
                self.card.center.x = -5 - (self.cardWidth / 2)
            }, completion: {
                (Bool) -> Void in
                // make it show front for next time
                if self.card.showingFront == false {
                    self.card.flipCard()
                }
                // clean up views
                self.currentDeckIndex = nextIndex
                self.card.removeFromSuperview()
                self.card = nextCard
            })
        } else {
            // only one card so wiggle it
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                () -> Void in
                self.card.center.x = self.card.center.x - 10
            }, completion: {
                (Bool) -> Void in
                self.wiggleBack()
            })
        }
    }
    
    // go to previous card
    @objc func handleSwipeRight(_ recognizer: UITapGestureRecognizer) {
        // more than 1 card, move to previous
        if deckSize > 1 {
            var prevIndex = currentDeckIndex - 1
            if prevIndex < 0 {
                prevIndex = deckSize - 1
            }
            let prevCard: FlashCard = deck.getCardAtIndex(index: prevIndex)
            
            // update the card's frame and it's label's frame
            prevCard.setFrame(f: cardFrame)
            prevCard.center.x = -5 - (cardWidth / 2)
            self.view.addSubview(prevCard)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                () -> Void in
                prevCard.center.x = self.horizontalCenter
                self.card.center.x = UIScreen.main.bounds.size.width + 5 + (self.cardWidth / 2)
            }, completion: {
                (Bool) -> Void in
                // make it show front for next time
                if self.card.showingFront == false {
                    self.card.flipCard()
                }
                // clean up views
                self.currentDeckIndex = prevIndex
                self.card.removeFromSuperview()
                self.card = prevCard
            })
        } else {
            // only one card so wiggle it
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                () -> Void in
                self.card.center.x = self.card.center.x + 10
            }, completion: {
                (Bool) -> Void in
                self.wiggleBack()
            })
        }
    }
    
    // used to move card back to center after swiping left/right with only 1 card in deck
    private func wiggleBack() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            () -> Void in
            self.card.center.x = self.horizontalCenter
        }, completion: {
            (Bool) -> Void in
        })
    }
    
    // dismiss the view
    @objc func backButtonPressed(_ recognizer: UITapGestureRecognizer) {
        self.presentingViewController?.dismiss(animated: false, completion: {
            () -> Void in
            print("Study view controller dismissed...")
        })
    }
    
}
