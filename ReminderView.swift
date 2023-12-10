//
//  ReminderView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/4/23.


import SwiftUI
import Foundation
import UserNotifications

struct ReminderView: View {
    //The state of the toggle on/off for daily reminder
    @AppStorage("isOn") var isOn = false
    // Save the notification time set by user for daily reminder
    @AppStorage("notificationTimeString") var notificationTimeString = ""
    @State private var description = ""
    
    var body: some View {
        ZStack{
            //background color
            Color(hex:"E7EDEB").ignoresSafeArea()
            List {
                Section(header: Text("Medicine Detail")) {
                    Text("PLACEHOLDER FOR MEDICINE DETAIL")
                }
                
                Section(header: Text("Daily Reminder")) {
                    
                    Toggle("Medicine Reminder", isOn: $isOn)
                        .onChange(of: isOn) { isOn in
                            handleIsOnChange(isOn: isOn)
                        }
                    // Show the date picker
                    if isOn {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $description)
                            
                            if description.isEmpty {
                                Text("Short description of the medicine")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                            }
                        }
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
            }
            .navigationTitle("Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(PlainListStyle())
            .background(Color(hex: "#E7EDEB"))
            }
    }
}

private extension ReminderView {
    
    // on/off the daily reminder
    private func handleIsOnChange(isOn: Bool) {
        if isOn {
            NotificationManager.requestNotificationAuthorization()
            NotificationManager.scheduleNotification(notificationTimeString: notificationTimeString, description: description)
        } else {
            NotificationManager.cancelNotification()
        }
    }
    
    private func handleNotificationTimeChange() {
        NotificationManager.cancelNotification()
        NotificationManager.requestNotificationAuthorization()
        NotificationManager.scheduleNotification(notificationTimeString: notificationTimeString, description: description)
    }
}

struct NotificationManager {
    // Request user authorization for notifications
    static func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            //schedule
            if success {
                print("Notification authorization granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // Schedule notification at selected time
    static func scheduleNotification(notificationTimeString: String, description: String) {
//        @Binding var description: String
        
        // Convert from string to date
        guard let date = DateHelper.dateFormatter.date(from: notificationTimeString) else {
            return
        }
        
        // Instantiate a variable for UNMutableNotificationContent
        let content = UNMutableNotificationContent()
        // Notification title
        content.title = "Take your medicine. NOW."
        // Notification body
        content.body = description
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
