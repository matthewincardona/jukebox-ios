//
//  MessagesViewModel.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/5/24.
//

import Foundation
import SwiftUI

struct SongRequestsView: View {
    @ObservedObject var socketManager = SongRequestSocketManager.shared

    var body: some View {
        NavigationView {
            List {
                ForEach(socketManager.messages, id: \.self) { message in
                    Text(message).padding()
                }
            }
            .navigationTitle("Requests")
        }
    }
}


struct SongRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        SongRequestsView()
    }
}
