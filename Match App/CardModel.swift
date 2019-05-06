//
//  CardModel.swift
//  Match App
//
//  Created by Warren Chan on 2019-04-02.
//  Copyright © 2019 Warren Chan. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        var generatedNumbersArray = [Int]()
        // Declare an array to store the generated cards
        var generatedCardArray = [Card]()
        
        // Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                // Log the number
                print(randomNumber)
                
                generatedNumbersArray.append(Int(randomNumber))
                
                // Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                //Add the created card
                generatedCardArray.append(cardOne)
                
                // Create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardArray.append(cardTwo)
                
                // OPTIONAL: Make it so we only have unique pairs of cards
            }
            
            
        }
        
        // TODO: Randomize the array
        print(generatedCardArray.count)
        
        for i in 0...generatedCardArray.count-1{
            
            // Find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardArray.count)))
            
            let temporaryStorage = generatedCardArray[i]
            generatedCardArray[i] = generatedCardArray[randomNumber]
            generatedCardArray[randomNumber] = temporaryStorage
            
        }
        
        
        
        // Return the array
        return generatedCardArray
        
    }
    
}
