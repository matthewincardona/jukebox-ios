//
//  ContentView.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/1/24.
//

import SwiftUI
import Combine

// SwiftUI View
struct QueueView: View {
    @State private var searchQuery = ""
    @State private var songs: [String] = []
    @ObservedObject var spotifyAPI = SpotifyAPI()

    var body: some View {
        VStack {
            TextField("Search Songs", text: $searchQuery, onCommit: {
                spotifyAPI.searchSongs(query: searchQuery) { results in
                    self.songs = results
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            List(songs, id: \.self) { song in
                Text(song)
            }
        }
        .onAppear {
            spotifyAPI.authenticate { success in
                if success {
                    print("Authentication successful")
                } else {
                    print("Authentication failed")
                }
            }
        }
    }
}

#Preview {
    QueueView()
}
