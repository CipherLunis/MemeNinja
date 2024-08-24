//
//  SoundManager.swift
//  MemeNinja
//
//  Created by Cipher Lunis on 8/24/24.
//

import Foundation
import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
   
    static let sharedInstance = SoundManager()
   
    private override init() {}
   
    var players =  [URL:AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()
   
    public func playSound(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            return
        }
       
        if let player = players[url] { // player exists for the sound
            if(player.isPlaying == false) {
                player.prepareToPlay()
                player.play()
            } else {
                let duplicatePlayer = try! AVAudioPlayer(contentsOf: url)
               
                // assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing
                duplicatePlayer.delegate = self
               
                // add duplicate to array so it doesn't get removed from memory before finishing
                duplicatePlayers.append(duplicatePlayer)
               
                duplicatePlayer.prepareToPlay()
               
                DispatchQueue.global().async {
                    duplicatePlayer.play()
                }
            }
        } else { // player does not exist for that sound
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                players[url] = player
                player.prepareToPlay()
               
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
   
}
