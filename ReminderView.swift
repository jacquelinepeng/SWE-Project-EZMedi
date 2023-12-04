//
//  ReminderView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/4/23.
//

import SwiftUI
import Foundation
import UserNotifications


struct ReminderView: View {
    // Save the state of the toggle on/off for daily reminder
    @AppStorage("isScheduled") var isScheduled = false
    // Save the notification time set by user for daily reminder
    @AppStorage("notificationTimeString") var notificationTimeString = ""
    
    var body: some View {
        List {
            Section(header: Text("Journal Reminder")) {
                // The toggle if the user want to use daily reminder feature
                Toggle("Daily Reminder", isOn: $isScheduled)
                    .onChange(of: isScheduled) { isScheduled in
                        handleIsScheduledChange(isScheduled: isScheduled)
                    }
                
                // Show the date picker if the daily reminder feature is on
                if isScheduled {
                    DatePicker("Notification Time", selection: Binding(
                        get: {
                            // Get the notification time schedule set by user
                            DateHelper.dateFormatter.date(from: notificationTimeString) ?? Date()
                        },
                        set: {
                            // On value set, change the notification time
                            notificationTimeString = DateHelper.dateFormatter.string(from: $0)
                            handleNotificationTimeChange()
                        }
                    // Only use hour and minute components, since this is a daily reminder
                    ), displayedComponents: .hourAndMinute)
                    // Use wheel date picker style, recommended by Apple
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ReminderView {
    
    // Handle if the user turned on/off the daily reminder feature
    private func handleIsScheduledChange(isScheduled: Bool) {
        if isScheduled {
            NotificationManager.requestNotificationAuthorization()
            NotificationManager.scheduleNotification(notificationTimeString: notificationTimeString)
        } else {
            NotificationManager.cancelNotification()
        }
    }
    
    // Handle if the notification time changed from DatePicker
    private func handleNotificationTimeChange() {
        NotificationManager.cancelNotification()
        NotificationManager.requestNotificationAuthorization()
        NotificationManager.scheduleNotification(notificationTimeString: notificationTimeString)
    }
}

struct NotificationManager {
    // Request user authorization for notifications
    static func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Notification authorization granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // Schedule daily notification at user-selected time
    static func scheduleNotification(notificationTimeString: String) {
        // Convert the time in string to date
        guard let date = DateHelper.dateFormatter.date(from: notificationTimeString) else {
            return
        }
        
        // Instantiate a variable for UNMutableNotificationContent
        let content = UNMutableNotificationContent()
        // The notification title
        content.title = "Write in your journal"
        // The notification body
        content.body = "Take a few minutes to write down your thoughts and feelings."
        content.sound = .default
        
        // Set the notification to repeat daily for the specified hour and minute
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // We need the identifier "journalReminder" so that we can cancel it later if needed
        // The identifier name could be anything, up to you
        let request = UNNotificationRequest(identifier: "journalReminder", content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request)
    }
    
    // Cancel any scheduled notifications
    static func cancelNotification() {
        // Cancel the notification with identifier "journalReminder"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["journalReminder"])
    }
}

struct DateHelper {
    // The universally used DateFormatter
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

// MARK: Preview

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView()
    }
}
