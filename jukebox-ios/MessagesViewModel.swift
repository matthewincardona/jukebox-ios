//
//  MessagesViewModel.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/5/24.
//

import Foundation
import SwiftUI

class MessagesViewModel: ObservableObject {
    @Published var messages: [String] = []
    @Published var statusMessage: String = "Connecting..."

    init() {
        setupNotifications()
        SocketManager.shared.configureSocketEvents()
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(forName: Notification.Name("SocketConnected"), object: nil, queue: .main) { [weak self] _ in
            self?.statusMessage = "Connected"
        }

        NotificationCenter.default.addObserver(forName: Notification.Name("SocketDisconnected"), object: nil, queue: .main) { [weak self] _ in
            self?.statusMessage = "Disconnected"
        }

        NotificationCenter.default.addObserver(forName: Notification.Name("SocketError"), object: nil, queue: .main) { [weak self] notification in
            if let userInfo = notification.userInfo, let error = userInfo["error"] as? String {
                self?.statusMessage = "Error: \(error)"
            }
        }
    }
}

struct MessagesView: View {
    @ObservedObject var viewModel = MessagesViewModel()

    var body: some View {
        NavigationView {
            List {
                Text(viewModel.statusMessage)
                    .foregroundColor(.red)
                    .bold()
                
                ForEach(viewModel.messages, id: \.self) { message in
                    Text(message)
                        .padding()
                }
            }
            .navigationTitle("Messages")
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
