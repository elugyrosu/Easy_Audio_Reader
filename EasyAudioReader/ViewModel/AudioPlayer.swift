//
//  AudioPlayer.swift
//  EasyAudioReader
//
//  Created by Jordan MOREAU on 16/06/2020.
//  Copyright © 2020 Jordan MOREAU. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {

    @Published var isPlaying = false
    var audioPlayer: AVAudioPlayer!
    
    func startPlayback (audio: URL) {
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: audio)
                       audioPlayer.delegate = self
                       audioPlayer.play()
                       isPlaying = true
        } catch {
            print("Playback failed.")
        }
        
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    

    
}
