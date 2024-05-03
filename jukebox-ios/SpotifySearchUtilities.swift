//
//  SpotifySearchUtilities.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/3/24.
//

// https://github.com/Peter-Schorn/SpotifyAPIExamples/blob/main/SpotifyAPIExamples/main.swift

import Foundation
import Combine
import SpotifyWebAPI

var cancellables: Set<AnyCancellable> = []
let dispatchGroup = DispatchGroup()

// Retrieve the client id and client secret from the environment variables.
let spotifyCredentials = getSpotifyCredentialsFromEnvironment()

let spotifyAPI = SpotifyAPI(
    authorizationManager: ClientCredentialsFlowManager(
        clientId: spotifyCredentials.clientId,
        clientSecret: spotifyCredentials.clientSecret
    )
)

// MARK: Search for Tracks and Albums

func searchForTracksAndAlbums() {
    do {
        // Attempt to authorize the application.
        try spotifyAPI.authorizationManager.waitUntilAuthorized()

        dispatchGroup.enter()
        spotifyAPI.search(
            query: "The Beatles",
            categories: [.track, .album],
            market: "US"
        )
        .sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Search completed.")
                case .failure(let error):
                    print("Search failed with error: \(error)")
                }
                dispatchGroup.leave()
            },
            receiveValue: { results in
                print("\nReceived results for search for 'The Beatles'")
                let tracks = results.tracks?.items ?? []
                print("found \(tracks.count) tracks:")
                print("------------------------")
                for track in tracks {
                    print("\(track.name) - \(track.album?.name ?? "nil")")
                }
                
                let albums = results.albums?.items ?? []
                print("\nfound \(albums.count) albums:")
                print("------------------------")
                for album in albums {
                    print("\(album.name)")
                }
            }
        )
        .store(in: &cancellables)
        dispatchGroup.wait()

    } catch {
        print("Authorization failed with error: \(error)")
    }
}

