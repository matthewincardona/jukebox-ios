//
//  ContentView.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/2/24.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            QueueView()
                .tabItem {
                    Label("Queue", systemImage: "music.note.list")
                }
            QRCodeView()
                .tabItem {
                    Label("Share", systemImage: "qrcode")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
