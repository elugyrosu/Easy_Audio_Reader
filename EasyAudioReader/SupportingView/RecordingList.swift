//
//  RecordingList.swift
//  EasyAudioReader
//
//  Created by Jordan MOREAU on 16/06/2020.
//  Copyright © 2020 Jordan MOREAU. All rights reserved.
//

import SwiftUI
import AVFoundation

struct RecordingList: View {
    @ObservedObject var fetcher = RecordingFetcher()

    var body: some View {
        List {
            
            ForEach(fetcher.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL)
            }.onDelete(perform: delete)
            
            }.navigationBarItems(trailing:
            Button(action: {
                 var urlsToDelete = [URL]()
                 self.fetcher.recordings.forEach { recording in
                     urlsToDelete.append(recording.fileURL)
                 }
                 self.fetcher.deleteRecording(urlsToDelete: urlsToDelete)

             }, label: {
                HStack{
                    Text("Delete all")
                    Image(systemName: "trash")

                }
            })
            )
        .navigationBarTitle("Tracks")
            .onAppear{
                self.fetcher.fetchRecordings()
        }

    }
    
    func delete(at offsets: IndexSet) {
          var urlsToDelete = [URL]()
          for index in offsets {
              urlsToDelete.append(fetcher.recordings[index].fileURL)
          }
        fetcher.deleteRecording(urlsToDelete: urlsToDelete)
      }
}

struct RecordingList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingList(fetcher: RecordingFetcher())
    }
}

struct RecordingRow: View {
    var audioURL: URL
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(audioURL.lastPathComponent)")
                    .font(.callout)
                Text(String(AVAsset.init(url: audioURL).duration.seconds))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {

                    self.audioPlayer.startPlayback(audio: self.audioURL)
                    
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()

                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
            }
            
        }
    }
    
  
}
