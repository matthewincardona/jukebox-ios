//
//  AppDelegate.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/5/24.
//

import Foundation
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Establish socket connection when the app launches
        SocketManager.shared.establishConnection()
        SocketManager.shared.configureSocketEvents()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Close socket connection when the app is about to terminate
        SocketManager.shared.closeConnection()
    }
}
