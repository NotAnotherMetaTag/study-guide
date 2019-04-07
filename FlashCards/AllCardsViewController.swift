//
//  AllCardsViewController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//

import UIKit

let CARDCELL: String = "CardCell"

class AllCardsViewController: UITableViewController {
    
    private var newButton: UIButton = UIButton()
    
    //offset and sizing info
    private let horizontalCenter: CGFloat = UIScreen.main.bounds.size.width / 2
    private let verticleOffset: CGFloat = UIScreen.main.bounds.size.height * 0.33
    private let cardHeight: CGFloat = 100
    private let cardWidth: CGFloat = 200
    
    private var cardFrame: CGRect = CGRect()
    
    init() {
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardFrame = CGRect(x: 10, y: 10, width: cardWidth, height: cardHeight)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = bgColor
        tableView.backgroundColor = bgColor
        
        //testing flash card
        //var fc: FlashCard = FlashCard()
        
        //while deck.count <= 15 {
        //   fc = FlashCard()
        //    deck.addCard(newCard: fc)
        //}
        //fileController.saveDeck()
    }
    
    // UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deck.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CARDCELL) ?? UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: CARDCELL)
        let cardEntry = UIView(frame: CGRect(x: 0.05*tableView.frame.width, y: 0, width: 0.9*tableView.frame.width, height: cardHeight))
        cardEntry.tag = 1
        let card = deck.getCardAtIndex(index: indexPath.row)
        card.setFrame(f: cardFrame)
        cardEntry.addSubview(card)
        cell.backgroundColor = bgColor
        cell.contentView.addSubview(cardEntry)
        cardEntry.isUserInteractionEnabled = false
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AllCardsViewController.handleTap(_:))))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cardHeight + (cardHeight * 0.25)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frameHeight: CGFloat = 50.0
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 40, width: view.frame.width, height: frameHeight))
        buttonContainer.backgroundColor = bgColor
        let title: UILabel = UILabel(frame: CGRect(x: view.frame.width * 0.25, y: 0, width: view.frame.width * 0.5, height: frameHeight))
        title.text = "All My FlashCards"
        title.font = UIFont(name: "papyrus", size: 30)
        //scale down font size to fit frame
        title.textAlignment = NSTextAlignment.center
        title.baselineAdjustment = UIBaselineAdjustment.alignCenters
        title.minimumScaleFactor = 0.001 //how small the font can be reduced
        title.adjustsFontSizeToFitWidth = true
        
        let newButton: UIButton = UIButton(frame: CGRect(x: view.frame.width * 0.80, y: 0, width: view.frame.width * 0.18, height: frameHeight))
        newButton.setImage(UIImage(named: "newButton"), for: .normal)
        newButton.isUserInteractionEnabled = true
        
        newButton.addTarget(self, action: #selector(AllCardsViewController.buttonPressed), for: UIControl.Event.touchUpInside)
        
        buttonContainer.addSubview(title)
        buttonContainer.addSubview(newButton)
        
        return buttonContainer
    }
    
    @objc func buttonPressed() {
        self.present(CreateEditViewController(fc: FlashCard())!, animated: true, completion: {() -> Void in
            print("Create edit view controller presented...")
        })
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.view is UITableViewCell {
            let cell = recognizer.view as! UITableViewCell
            let card: FlashCard = deck.getCardAtIndex(index: tableView.indexPath(for: cell)!.row)
            self.present(CreateEditViewController(fc: card)!, animated: true, completion: {() -> Void in
                print("Create edit view controller presented...")
            })
        }
        
    }
    
}
