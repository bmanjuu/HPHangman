//
//  BackgroundMusic.swift
//  HPHangman
//
//  Created by Betty Fung on 2/18/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import AVFoundation

class BackgroundMusic {
    
    static var audioPlayer = AVAudioPlayer()
    
    static func playSong(_ songName: String) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "\(songName)", ofType: "mp3")))
        } catch {
            print(error)
        }
    }
    
}
