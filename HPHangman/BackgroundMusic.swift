//
//  BackgroundMusic.swift
//  HPHangman
//
//  Created by Betty Fung on 2/18/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import AVFoundation

struct BackgroundMusic {
    
    static var audioPlayer = AVAudioPlayer()
    
    static func playSong(_ songName: String) {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers)
        } catch {
            print("could not set ambient audio session")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "\(songName)", ofType: "mp3")!))
            
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        } catch {
            print(LocalizedError.self)
        }
    }
    
    static func stopPlayingSong() {
        audioPlayer.stop()
    }
    
    static func isMusicPlaying() -> Bool {
        if audioPlayer.isPlaying {
            return true
        } else {
            return false 
        }
    }
    
}
