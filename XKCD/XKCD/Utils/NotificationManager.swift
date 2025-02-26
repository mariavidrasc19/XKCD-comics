//
//  NotificationManager.swift
//  XKCD
//
//  Created by Maria Vidrasc on 26.02.2025.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.scheduleNotificationEveryOneHour()
                print("Permisiune pentru notificări acordată.")
            } else if let error = error {
                print("Eroare la cererea permisiunii: \(error)")
            }
        }
    }

    func scheduleNotification(for comic: Comic) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Check XKCD app!"
        content.body = "\(comic.title) is now and fresh! Check it out!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "newComic_\(comic.id)", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotificationEveryOneHour() {
        let center = UNUserNotificationCenter.current()
        
        // Conținutul notificării
        let content = UNMutableNotificationContent()
        content.title = "Check XKCD app!"
        content.body = "A now comic may accure!"
        content.sound = .default
        
        // periodic trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
        
        let request = UNNotificationRequest(identifier: "everyoneHour", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
