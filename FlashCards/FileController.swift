//
//  FileController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 4/6/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//
//  Description:  This class handles creating and maintaining our
//                saved game data (the deck of flashcards).
//


import UIKit

class FileController {
    
    private let dirPath: String = "\(NSHomeDirectory())/fcsa"
    private let filePath: String = "\(NSHomeDirectory())/fcsa/deck.txt"
    
    init() {
        createDirectory()
    }
    
    // check if directory exists, if not create it
    private func createDirectory() {
        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDir) {
            // it already exists, this call doesn't need to do anything
        }
        else {
            // it doesnt exist yet, try to create it
            do {
                try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Error creating directory \(dirPath): \(error)")
            }
        }
    }
    
    // save the deck and all cards inside it
    func saveDeck() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: deck, requiringSecureCoding: false)
            if FileManager.default.createFile(atPath: filePath,
                                              contents: data,
                                              attributes: nil) {
                print("Deck Saved.")
            }
            else {
                print("File \(filePath) could not be created")
            }
        }
        catch {
            print("Error archiving data: \(error)")
        }
    }
    
    // load the saved deck and all cards inside it
    func loadDeck() {
        do {
            if let data = FileManager.default.contents(atPath: filePath) {
                // loads into our global deck variable
                deck = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Deck
                print("Deck Loaded.")
            }
            else {
                print("Deck not found, using new deck instead.")
                //default deck was already created in global initializer
            }
        }
        catch {
            print("Error unarchiving data: \(error)")
        }
    }
}
