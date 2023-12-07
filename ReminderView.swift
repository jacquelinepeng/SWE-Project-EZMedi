//
//  ReminderView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/4/23.


import SwiftUI
import Foundation
import UserNotifications

struct ReminderView: View {
    @AppStorage("isOn") var isOn = false
    @AppStorage("notificationTimeString") var notificationTimeString = ""
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
//    let dateRange: ClosedRange<Date> = {
//        let calendar = Calendar.current
//        let startComponents = DateComponents(year: 2020, month: 1, day: 1)
//        let endComponents = DateComponents(year: 2050, month: 12, day: 31, hour: 23, minute: 59, second: 59)
//        return calendar.date(from:startComponents)!
//        ...
//        calendar.date(from:endComponents)!
//    }()
    var body: some View {
        
        ZStack{
            //background color
            Color(hex:"E7EDEB").ignoresSafeArea()
            List {
                Toggle("Reminder", isOn: $isOn)
                    .onChange(of: isOn) { isOn in
                        handleIsOnChange(isOn: isOn)
                    }
                // Show the date picker if the daily reminder feature is on
                if isOn {
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date])

                    DatePicker("", selection: Binding(
                        get: {
                            // Get the notification time schedule set by user
                            DateHelper.dateFormatter.date(from: notificationTimeString) ?? Date()
                        },
                        set: {
                            // On value set, change the notification time
                            notificationTimeString = DateHelper.dateFormatter.string(from: $0)
                            handleNotificationTimeChange()
                        }
                    ), displayedComponents: .hourAndMinute)
                    // date picker
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
//            .listStyle(PlainListStyle())
            .background(Color(hex: "#E7EDEB"))

        }
    }
}

private extension ReminderView {
    
    // Handle if the user turned on/off the daily reminder feature
    private func handleIsOnChange(isOn: Bool) {
        let currentDate = Date()
        if isOn && (currentDate <= endDate){ //自动switch off reminder if the endDate is reached 不一定能用
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
                
    // Schedule daily notification at selected time
    static func scheduleNotification(notificationTimeString: String) {
        // Convert the time from string to date
        guard let date = DateHelper.dateFormatter.date(from: notificationTimeString) else {
            return
        }
    
        let content = UNMutableNotificationContent()
        // Notification title
        content.title = "It's time."
        // Notification body content
        content.body = "Take your medicine."
        content.sound = .default
        
        // Set the notification to repeat daily for the specified hour and minute
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "medicineReminder", content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request)
    }
    
    // Cancel any scheduled notifications
    static func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["medicineReminder"])
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

// Preview
struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView()
    }
}
