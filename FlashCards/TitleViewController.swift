//
//  TitleViewController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 3/21/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//

import UIKit

let bgColor = UIColor(red: 0.085, green: 0.527, blue: 0.903, alpha: 1)

class TitleViewController: UIViewController {
    
    private var enterButton: UIButton = UIButton()
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
        
        //setup display
        titleImage = UIImageView(frame: CGRect(x: horizontalCenter - (imageWidth / 2), y: verticleOffset - (imageHeight / 2), width: imageWidth, height: imageHeight))
        titleImage.image = UIImage(named: "title")
        
        enterButton = UIButton(type: UIButton.ButtonType.custom)
        enterButton.frame = CGRect(x: horizontalCenter - (buttonWidth / 2), y: buttonVerticleOffset - (buttonHeight / 2), width: buttonWidth, height: buttonHeight)
        enterButton.setImage(UIImage(named: "enterButton"), for: UIControl.State.normal)
        //rgb on enter button is 8.5/82.7/90.3
        enterButton.isEnabled = true
        
        self.view.backgroundColor = bgColor
        self.view.addSubview(titleImage)
        self.view.addSubview(enterButton)
        
        enterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TitleViewController.handleTap(_:))))
        
    }//end viewDidLoad
    
    //handles enter button's tap to present all cards view controller
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        self.present(AllCardsViewController(), animated: true, completion: {() -> Void in
            print("All cards view controller presented...")
        })
    }
    
}
