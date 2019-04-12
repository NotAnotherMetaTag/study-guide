//
//  FileController.swift
//  FlashCards
//
//  Created by Horn, Nicholas G on 4/6/19.
//  Copyright © 2019 Emily Clark. All rights reserved.
//

import UIKit

class FileController {
    
    private let dirPath: String = "\(NSHomeDirectory())/fcsa"
    private let filePath: String = "\(NSHomeDirectory())/fcsa/deck.txt"
    
    init() {
        createDirectory()
    }
    
    private func createDirectory() {
        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDir) {
            if isDir.boolValue {
                //print("\(dirPath) exists and is a directory")
            }
            else {
                //print("\(dirPath) exists and is not a directory")
            }
        }
        else {
            //print("\(dirPath) does not exist")
            do {
                try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                //print("Error creating directory \(dirPath): \(error)")
            }
        }
    }
    
    func saveDeck() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: deck, requiringSecureCoding: false)
            if FileManager.default.createFile(atPath: filePath,
                                              contents: data,
                                              attributes: nil) {
                //print("File \(filePath) successfully created")
            }
            else {
                //print("File \(filePath) could not be created")
            }
        }
        catch {
            //print("Error archiving data: \(error)")
        }
    }
    
    func loadDeck() {
        do {
            if let data = FileManager.default.contents(atPath: filePath) {
                //print("Retrieving data from file \(filePath)")
                deck = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Deck
            }
            else {
                //print("No data available in file \(filePath)")
                //default deck exists
            }
        }
        catch {
            //print("Error unarchiving data: \(error)")
        }
    }
}
