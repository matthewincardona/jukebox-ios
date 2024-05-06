//
//  SocketIO.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/5/24.
//

import Foundation
import SwiftUI
import SocketIO

class SocketManager {
    static let shared = SocketManager()
    private var manager: SocketIO.SocketManager!
    var socket: SocketIOClient!
    var messages: [String] = []

    private init() {
        let url = URL(string: "https://jukebox.matthewincardona.com")!
        self.manager = SocketIO.SocketManager(socketURL: url, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }

    func establishConnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }

    func configureSocketEvents() {
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected")
            NotificationCenter.default.post(name: Notification.Name("SocketConnected"), object: nil)
        }

        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected")
            NotificationCenter.default.post(name: Notification.Name("SocketDisconnected"), object: nil)
        }

        socket.on(clientEvent: .error) { data, ack in
            if let error = data[0] as? Error {
                print("socket error: \(error.localizedDescription)")
                NotificationCenter.default.post(name: Notification.Name("SocketError"), object: nil, userInfo: ["error": error.localizedDescription])
            }
        }

        socket.on("newMessage") { [weak self] data, ack in
            if let msg = data[0] as? String {
                self?.messages.append(msg)
                print("Received message: \(msg)")
            }
        }
    }
}
