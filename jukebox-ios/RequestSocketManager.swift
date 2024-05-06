//
//  SocketIO.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/5/24.
//

import Foundation
import SwiftUI
import SocketIO

class SongRequestSocketManager: ObservableObject {
    static let shared = SongRequestSocketManager()
    private var manager: SocketIO.SocketManager!
    var socket: SocketIOClient!

    @Published var messages: [String] = []
    var statusHandler: ((String) -> Void)?

    private init() {
        let url = URL(string: "https://jukebox.matthewincardona.com")!
        self.manager = SocketIO.SocketManager(socketURL: url, config: [.log(true), .compress])
        socket = manager.defaultSocket
        configureSocketEvents()
        establishConnection()
    }
    
    func establishConnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }

    func configureSocketEvents() {
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("Socket connected - event triggered")
            self?.statusHandler?("Connected")
        }

        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("Socket disconnected")
            self?.statusHandler?("Disconnected")
        }

        socket.on(clientEvent: .error) { [weak self] data, ack in
            if let error = data[0] as? Error {
                print("Socket error: \(error.localizedDescription)")
                self?.statusHandler?("Error: \(error.localizedDescription)")
            }
        }

        socket.on("chat message") { [weak self] data, ack in
            if let msg = data[0] as? String {
                DispatchQueue.main.async {
                    self?.messages.append(msg)
                    print("Received chat message: \(msg)")
                }
            }
        }
    }
}
