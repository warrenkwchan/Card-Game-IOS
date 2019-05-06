//
//  ViewController.swift
//  Match App
//
//  Created by Warren Chan on 2019-04-01.
//  Copyright © 2019 Warren Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var secondFlippedCardIndex:IndexPath?
    
    var timer:Timer?

    var milliseconds:Float = 50*1000 // 30 seconds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Call the gerCards method of the card model
        
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Set cell size
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let width = self.collectionView.frame.size.width
        let itemWidth = (width - (10*3))/4
        let itemHeight = itemWidth * 1.4177
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        SoundManager.playSound(.shuffle)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        //dispose of any resources that can be recreated
    }
    
    // Mark: - Timer Methods
    
    @objc func timerElapsed(){
        milliseconds -= 1
        
        //Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        timerLabel.text = "Time Remaining: \(seconds)"
        
        if milliseconds <= 0 {
            
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //Check if any card unmathced
            checkGameEnded()
        }
        
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    // Mark: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        
        // Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // Set that card for the cell 
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        // Get the cell that the user selected
        if milliseconds == 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        
        // Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false{
            
            //Flip the card
            cell.flip()
            
            // play the flip sound
            SoundManager.playSound(.flip)
            
            card.isFlipped = true
            
            // Determine if it's the first card or second card that's flipped over
            
            if firstFlippedCardIndex == nil {
                
                firstFlippedCardIndex = indexPath
                
            }
            else {
                // This is the second card being flipped
                checkForMatches(indexPath)
             
                
            }
            
        }
        else {
            cell.flipBack()
            
            card.isFlipped = false
        }
        //Flip the card
        
       
        //compare
        
      
    
        
    }
    
    
    //Mark: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath){
        
        
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName {
            
            SoundManager.playSound(.match )
            
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards left unmatched
            
        }
            
        else{
            
            SoundManager.playSound(.nomatch)
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
            
        }
        
        // Tell the collectionview to reload the cell of the first card if it is nil
        
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded() {
        
        var isWon = true
        
        for card in cardArray{
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        if isWon == true {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won"
        }
        else {
            
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
            
        }
        
        // Show won/ lost messaging
        showAlert(title, message)
        
    
        
    }

    
    func showAlert(_ title:String, _ message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
} // End ViewController class

