//
//  NotificationManager.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 10/2/21.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    @Published var settings: UNNotificationSettings?
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        // Handles all notification behavior in app (requesting auth, scheduling delivery, & handling actions). current() is shared instance
        UNUserNotificationCenter.current()
            // Request auth to show notif.; options denotes notif behavior (displaying alert, playing sound, badge)
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                // fetch notif settings after user grants auth
                self.fetchNotificationSettings()
                // Completion handler receives boolean indicating whether user granted auth; call completion handler with boolean value
                completion(granted)
            }
    }
    
    func fetchNotificationSettings() {
        // 1 requests notification settings auth'd by app. Settings return async; UNNotifSet. manages notif related settings and auth status of app. settings is an instance of it
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            // 2 Completion block may be called on background thread; here we update settings property on main thread as chaning its value updates UI
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    // 1 takes in parameter of type task (model) whoich holds all data related to any task
    func scheduleNotification(observation: Observation) {
        // 2 You start by creating notification by populating notif content. UNMutNotifCont holds payload for local notif. Here, we populate title and body of notif
        let content = UNMutableNotificationContent()
        content.title = observation.name ?? "Name not found"
        content.body = "Check on your mushrooms!"
        // Notifications content categoryIdentifier set to ident. used when UNNotifCat was instantiated
        content.categoryIdentifier = "Observation Category"
        // 3 Abstract class that triggers delivery of notif. We check if reminderType of task is time based with valid time interval. Next, we create time-interval based notif trigger using UNTimeIntNotifTrigger. We use this type of trigger to schedule timers. Constructor also takes in boolean parameter (repeats) this determines whether the notification needs to resched after being delivered.
        var trigger: UNNotificationTrigger?
        // 1 Check if reminder of task has a date set
        // 2 Create notification trigger of type UNCalNotifTrigger. The calendar trigger delivers a notification based on a particular date and time. It extracts dateComponents from the date user selected. Specifying only the time components will trigger a notification at specified time.
        if let date = observation.reminder {
            trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date), repeats: false)
            
            // 3 After trigger definition, next step is to create notif request. We create new request using UNNotifReq and specify an identifier, content, & trigger. Each task has a unique identifier. We pass that as notif identifier
            if let trigger = trigger {
                let request = UNNotificationRequest(identifier: "\(String(describing: observation.id))", content: content, trigger: trigger)
                
                // 4 Schedule notif by adding request to UNUserNotifCenter. Completion handler as error object that indicates if problem occurs when scheduling notif
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
    
    // Ensure removal of pending notif up on task completion. We pass identififer of task in an arry. This is very useful for tasks that have repeats set to true
    func removeScheduledNotification(observation: Observation) {
      UNUserNotificationCenter.current()
        .removePendingNotificationRequests(withIdentifiers: ["\(String(describing: observation.id))"])
    }
    
} // End of Class
