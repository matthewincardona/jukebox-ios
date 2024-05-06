//
//  SpotifyApi.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/5/24.
//

import Foundation
import Combine

class SpotifyAPI: ObservableObject {
    private var clientId: String {
        ProcessInfo.processInfo.environment["SPOTIFY_CLIENT_ID"] ?? "Fallback_Client_ID"
    }
    
    private var clientSecret: String {
        ProcessInfo.processInfo.environment["SPOTIFY_CLIENT_SECRET"] ?? "Fallback_Client_Secret"
    }
    
    @Published var accessToken: String?
    
    private var authorizationHeader: String {
        let credentialData = "\(clientId):\(clientSecret)".data(using: .utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        return "Basic \(base64Credentials)"
    }
    
    func authenticate(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let token = json["access_token"] as? String {
                DispatchQueue.main.async {
                    self.accessToken = token
                }
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    func searchSongs(query: String, completion: @escaping ([String]) -> Void) {
        guard let accessToken = accessToken,
              let url = URL(string: "https://api.spotify.com/v1/search?type=track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")") else {
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let tracks = json["tracks"] as? [String: Any],
               let items = tracks["items"] as? [[String: Any]] {
                let songs = items.compactMap { $0["name"] as? String }
                DispatchQueue.main.async {
                    completion(songs)
                }
            } else {
                completion([])
            }
        }.resume()
    }
}
