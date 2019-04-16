//
//  AllCardsViewController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//
//  Description:  Table view that displays all mock
//                front/back views of each of our flash cards.
//                Also provides navigation and utility
//                features for user interaction with the deck.
//

import UIKit

// used for our reusable cell
let CARDCELL: String = "CardCell"

class AllCardsViewController: UITableViewController {
    
    private var newButton: UIButton = UIButton()
    private var backButton: UIButton = UIButton()
    private var studyButton: UIButton = UIButton()
    
    // offset and sizing info
    private let horizontalCenter: CGFloat = UIScreen.main.bounds.size.width / 2
    private let verticleOffset: CGFloat = UIScreen.main.bounds.size.height * 0.33
    private let cardHeight: CGFloat = 100
    private let cardWidth: CGFloat = UIScreen.main.bounds.size.width * 0.45

    // used to update the sizing of the cards
    private var cardFrame1: CGRect = CGRect()
    private var cardFrame2: CGRect = CGRect()
    
    // used for card label sizing
    private var labelFrame: CGRect = CGRect()
    
    // color used in header/footer to make them stand out
    private var overlayColor: UIColor = UIColor(red: 0.085, green: 0.793, blue: 0.727, alpha: 1)
    
    init() {
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // lines the card frames up side by side
        cardFrame1 = CGRect(x: (UIScreen.main.bounds.size.width * 0.20) - (cardWidth / 2), y: 10, width: cardWidth, height: cardHeight)
        cardFrame2 = CGRect(x: (UIScreen.main.bounds.size.width * 0.70) - (cardWidth / 2), y: 10, width: cardWidth, height: cardHeight)
        
        // label sizing within card
        labelFrame = CGRect(x: 5, y: 5, width: cardWidth - 10, height: cardHeight - 10)

        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = bgColor
        tableView.backgroundColor = bgColor
        
        // make sure everything is showing front
        deck.setAllCardsShowingFront()
    }
    
    // only need one section: flash cards
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // a row for each card in the deck
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deck.count
    }
    
    // loads all the rows with a cell containing our side by side "cards"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CARDCELL) ?? UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: CARDCELL)
        
        // container for our front/back views
        let cardEntry = UIView(frame: CGRect(x: 0.05*tableView.frame.width, y: 0, width: 0.9*tableView.frame.width, height: cardHeight))
        cardEntry.tag = 1
        
        // the card we are displaying
        let card = deck.getCardAtIndex(index: indexPath.row)
        
        // load the frame
        let cardImage: UIImageView = UIImageView(image: UIImage(named: "index-card"))
        cardImage.frame = cardFrame1
        let cardImage2: UIImageView = UIImageView(image: UIImage(named: "index-card"))
        cardImage2.frame = cardFrame2
        
        // create label for the question view
        let cardILabel1: UILabel = UILabel(frame: labelFrame)
        cardILabel1.text = card.qText
        cardILabel1.font = UIFont(name: "papyrus", size: 30)
        // scale down font size to fit frame
        cardILabel1.textAlignment = NSTextAlignment.center
        cardILabel1.baselineAdjustment = UIBaselineAdjustment.alignCenters
        cardILabel1.minimumScaleFactor = 0.001 //how small the font can be reduced
        cardILabel1.numberOfLines = 8 //max number of lines for wrapping
        cardILabel1.adjustsFontSizeToFitWidth = true
        
        // create label for the answer view
        let cardILabel2: UILabel = UILabel(frame: labelFrame)
        cardILabel2.text = card.aText
        cardILabel2.font = UIFont(name: "papyrus", size: 30)
        // scale down font size to fit frame
        cardILabel2.textAlignment = NSTextAlignment.center
        cardILabel2.baselineAdjustment = UIBaselineAdjustment.alignCenters
        cardILabel2.minimumScaleFactor = 0.001 //how small the font can be reduced
        cardILabel2.numberOfLines = 8 //max number of lines for wrapping
        cardILabel2.adjustsFontSizeToFitWidth = true
        
        // add labels to our mock card views
        cardImage.addSubview(cardILabel1)
        cardImage2.addSubview(cardILabel2)
        
        // add the mock cards to our container
        cardEntry.addSubview(cardImage)
        cardEntry.addSubview(cardImage2)
        
        cell.backgroundColor = bgColor
        // add container to cell
        cell.contentView.addSubview(cardEntry)
        cardEntry.isUserInteractionEnabled = false
        
        // tapping a cell will open the editor for that card
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AllCardsViewController.handleTap(_:))))
        
        return cell
    }
    
    // sets the height for our rows based on card height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cardHeight + (cardHeight * 0.25)
    }
    
    // header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // setup for header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frameHeight: CGFloat = 50.0
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 40, width: view.frame.width, height: frameHeight))
        buttonContainer.backgroundColor = overlayColor
        let title: UILabel = UILabel(frame: CGRect(x: view.frame.width * 0.25, y: 10, width: view.frame.width * 0.5, height: frameHeight))
        title.text = "All My FlashCards"
        title.font = UIFont(name: "papyrus", size: 30)
        // scale down font size to fit frame
        title.textAlignment = NSTextAlignment.center
        title.baselineAdjustment = UIBaselineAdjustment.alignCenters
        title.minimumScaleFactor = 0.001 //how small the font can be reduced
        title.adjustsFontSizeToFitWidth = true
        
        // used to create a new card
        let newButton: UIButton = UIButton(frame: CGRect(x: view.frame.width * 0.80, y: 5, width: view.frame.width * 0.18, height: frameHeight))
        newButton.setImage(UIImage(named: "newButton"), for: .normal)
        newButton.isUserInteractionEnabled = true
        
        newButton.addTarget(self, action: #selector(AllCardsViewController.newPressed), for: UIControl.Event.touchUpInside)
        
        let deleteAllButton: UIButton = UIButton(frame: CGRect(x: (view.frame.width * 0.03), y: 5, width: view.frame.width * 0.18, height: frameHeight))
        deleteAllButton.setImage(UIImage(named: "deleteAllButton"), for: .normal)
        deleteAllButton.isUserInteractionEnabled = true
        
        deleteAllButton.addTarget(self, action: #selector(AllCardsViewController.deleteButtonPressed), for: UIControl.Event.touchUpInside)
        
        buttonContainer.addSubview(title)
        buttonContainer.addSubview(newButton)
        buttonContainer.addSubview(deleteAllButton)
        
        return buttonContainer
    }
    
    // footer height
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    // setup footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let frameHeight: CGFloat = 50.0
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: frameHeight))
        buttonContainer.backgroundColor = overlayColor
        
        let buttonWidth: CGFloat = view.frame.width * 0.18
        
        // return to TitleView
        backButton = UIButton(frame: CGRect(x: (view.frame.width * 0.33) - (buttonWidth / 2), y: 5, width: buttonWidth, height: frameHeight))
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.isUserInteractionEnabled = true
        
        // try to go to StudyView
        studyButton = UIButton(frame: CGRect(x: (view.frame.width * 0.66) - (buttonWidth / 2), y: 5, width: buttonWidth, height: frameHeight))
        studyButton.setImage(UIImage(named: "studyButton"), for: .normal)
        studyButton.isUserInteractionEnabled = true
        
        // add button targets
        backButton.addTarget(self, action: #selector(AllCardsViewController.backPressed), for: UIControl.Event.touchUpInside)
        
        studyButton.addTarget(self, action: #selector(AllCardsViewController.studyPressed), for: UIControl.Event.touchUpInside)
        
        buttonContainer.addSubview(backButton)
        buttonContainer.addSubview(studyButton)
        
        return buttonContainer
    }
    
    // used to rebuild table when this view comes into focus.
    // ie: if this view presents CreateEditView and that view saves a card,
    // this ensures that when CreateEditView is dismissed our table is updated.
    override func viewWillAppear(_ animated: Bool){
        // make sure everything is showing front
        deck.setAllCardsShowingFront()
        tableView.reloadData()
    }
    
    // presents CreateEditView while giving it a new default FlashCard object
    @objc func newPressed() {
        self.present(CreateEditViewController(fc: FlashCard())!, animated: true, completion: {() -> Void in
            print("Create edit view controller presented...")
        })
    }
    
    // dismiss this view
    @objc func backPressed() {
        presentingViewController?.dismiss(animated: true, completion: {() -> Void in
            print("All cards view controller dismissed...")
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
    
    // presents CreateEditView while giving it a reference to the flashcard at the tapped row
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.view is UITableViewCell {
            let cell = recognizer.view as! UITableViewCell
            let card: FlashCard = deck.getCardAtIndex(index: tableView.indexPath(for: cell)!.row)
            self.present(CreateEditViewController(fc: card)!, animated: true, completion: {() -> Void in
                print("Create edit view controller presented...")
            })
        }
        
    }
    //this delete button removes ALL cards in the deck
    @objc func deleteButtonPressed(_ recognizer: UITapGestureRecognizer) {
        let alert: UIAlertController = UIAlertController(title: "Are you sure?", message: "Deleted flash cards can not be recovered. This will delete ALL cards.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Keep All", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            //do nothing
        }))
        alert.addAction(UIAlertAction(title: "Delete All", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            //only need to make changes if there are any cards in deck
            if (deck.count > 0) {
                deck = Deck()
                
                //save the deck
                fileController.saveDeck()
                self.tableView.reloadData()
            }
            
        }))
        
        self.present(alert, animated: false, completion: {() -> Void in
            
        })
    }
}
