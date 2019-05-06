//
//  SoundManager.swift
//  Match App
//
//  Created by Warren Chan on 2019-04-06.
//  Copyright © 2019 Warren Chan. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
        
    }
    
    static func playSound(_ effect:SoundEffect){
        
        var soundFilename = ""
        
        
        
        switch effect {
            
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFilename) in the bundle")
            return
        }
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            //
            audioPlayer?.play()
        }
        catch{
            
            print("Coundn't create the audio player object for sound file \(soundFilename)")
            
        }
        //
     
        
    }
}
