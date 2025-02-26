//
//  XKCDApp.swift
//  XKCD
//
//  Created by Maria Vidrasc on 18.02.2025.
//

import SwiftUI
import UserNotifications

@main
struct XKCDApp: App {
    var body: some Scene {
        WindowGroup {
            ComicsNavigationView()
                .onAppear {
                    NotificationManager.shared.requestNotificationPermission()
                }
        }
    }
}
