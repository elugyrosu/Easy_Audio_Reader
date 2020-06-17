//
//  MicrophoneMonitor.swift
//  EasyAudioReader
//
//  Created by Jordan MOREAU on 15/06/2020.
//  Copyright © 2020 Jordan MOREAU. All rights reserved.
//

import Foundation
import AVFoundation

class AudioRecorder: ObservableObject {
    
    // MARK - Properties
    
    private var audioRecorder: AVAudioRecorder
    private var timer: Timer
    private var currentSample: Int
    private let numberOfSamples: Int
    
    // MARK - Observed Properties
    
    @Published public var soundSamples: [Float]
    @Published public var isRecording = false
    @Published public var isCapturedMode = false
    
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    private var time: Double = 0
    
    // MARK - Initialization
    
    init(numberOfSamples: Int) {
        self.numberOfSamples = numberOfSamples // In production check this is > 0.
        self.soundSamples = [Float](repeating: -50, count: numberOfSamples)
        self.currentSample = 0
        self.audioRecorder = AVAudioRecorder()
        self.timer = Timer()
    }
    
  
    // MARK - Methods
    
    func startRecording(){
        
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    fatalError("You must allow audio recording for this demo to work")
                }
            }
        }
//        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            self.isRecording = true
            
            startMonitoring()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func stopRecording(){
        isRecording = false
        timer.invalidate()
        seconds = 0
        minutes = 0
        time = 0
        audioRecorder.stop()
        self.currentSample = 0
        self.soundSamples = [Float](repeating: -50, count: numberOfSamples)
    }
    
    private func startMonitoring() {
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        if isCapturedMode{
            var bufferSoundSamples = [Float](repeating: -50, count: self.numberOfSamples)
            var bufferCount = 0

            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in

                self.audioRecorder.updateMeters()
                bufferSoundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
                self.currentSample = (self.currentSample + 1) % self.numberOfSamples
                
                if bufferCount == self.numberOfSamples{
                    self.soundSamples = bufferSoundSamples
                    bufferSoundSamples = [Float](repeating: -50, count: self.numberOfSamples)
                    self.currentSample = 0
                    bufferCount = 0
                }
                bufferCount += 1
                self.time += 1
                
                self.seconds = Int(self.time * 0.01) % 60
                self.minutes = (Int(self.time * 0.01)/60)%60

            })
        }else{
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                self.audioRecorder.updateMeters()
                self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
                self.currentSample = (self.currentSample + 1) % self.numberOfSamples
                
                self.time += 1
                
                self.seconds = Int(self.time * 0.01) % 60
                self.minutes = (Int(self.time * 0.01)/60)%60
            })
        }
    }

    // MARK - Desinitialization
    
    deinit {
        if isRecording{
            stopRecording()
        }
    }
}
