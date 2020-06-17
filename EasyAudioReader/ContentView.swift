//
//  ContentView.swift
//  EasyAudioReader
//
//  Created by Jordan MOREAU on 15/06/2020.
//  Copyright © 2020 Jordan MOREAU. All rights reserved.
//

import SwiftUI

private let numberOfSamples: Int = 200

struct ContentView: View {
    
    // MARK - Properties
    
    @ObservedObject private var audioRecorder = AudioRecorder(numberOfSamples: numberOfSamples)
    

    // MARK - Methods
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
    
    // MARK - Body
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Spacer()
                if audioRecorder.isRecording{
                    HStack(alignment: .center, spacing: 0) {
                            ForEach(self.audioRecorder.soundSamples, id: \.self) { level in
                                BarView(value: self.normalizeSoundLevel(level: level))
                            }
                    }
                    Spacer()
                }
                HStack {
                    Text("\(audioRecorder.minutes)" + " :")
                        .padding(.trailing, -5)
                    if audioRecorder.seconds < 10{
                        Text("0" + "\(audioRecorder.seconds)")

                    }else{
                        Text("\(audioRecorder.seconds)")

                    }
                }

                
                HStack(alignment: .center){
                    Spacer()
                    Button(action: {
                        self.audioRecorder.isCapturedMode.toggle()
                    }, label:{
                        Image(systemName: self.audioRecorder.isCapturedMode ? "waveform.circle" : "waveform.circle.fill")
                            .resizable()
                            .foregroundColor(.black )
                            .scaledToFit()
                    })
                        .frame(width: 50)

                    
                    Button(action: {
                        if self.audioRecorder.isRecording{
                            self.audioRecorder.stopRecording()
                        }else{
                            self.audioRecorder.startRecording()
                        }
                        
                    }) {
                        Image(systemName: self.audioRecorder.isRecording ? "stop.circle" : "mic.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(self.audioRecorder.isRecording ? .red : .black)
                    }
                    .frame(width: 80)
                    .padding(.horizontal, 50)

                    NavigationLink(destination: RecordingList()){
                        Image(systemName: "line.horizontal.3.decrease.circle")
                        .resizable()
                        .foregroundColor(.black)

                        .scaledToFit()
                            .frame(width: 50)
                    }
                    Spacer()
                    
                }
            .padding(30)
            }
        .navigationBarTitle("Easy Audio Reader")
        }
    }
}

    // MARK - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

    // MARK - BarView


struct BarView: View {
    var value: CGFloat
    var body: some View {
        ZStack{
            Rectangle()
                .frame(height: value)
        }
    }
}

