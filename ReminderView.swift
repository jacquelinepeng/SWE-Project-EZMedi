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
    @ObservedObject private var vm = ProfileViewModel()
    
    var parameter: String?  //Parameter is the ndccode from the profileview pass into the reminderview
    public let medicines = [
        Medicine(id: 1, NDC:"0363-0587-14", name: "Aspirin", details: "Used to reduce pain, fever, or inflammation."),
        Medicine(id: 2, NDC:"0904-5853-40", name: "Ibuprofen", details: "It's used for pain relief and reducing inflammation."),
        Medicine(id: 3, NDC:"50580-600-01", name: "Acetaminophen(Tylenol)", details: "Pain relief, fever reduction, not anti-inflammatory."),
        Medicine(id: 4, NDC:"0591-0405-01", name: "Lisinopril", details: "Angiotensin-converting enzyme (ACE) inhibitor used to treat hypertension."),
        Medicine(id: 5, NDC:"60429-111-01", name: "Metformin", details: "Antidiabetic medication, helps control blood sugar levels in type 2 diabetes."),
        Medicine(id: 6, NDC:"0378-3953-77", name: "Atorvastatin (Lipitor)", details: "Effect: Statin medication, lowers cholesterol levels."),
        Medicine(id: 7, NDC:"51079-443-20", name: "Levothyroxine (Synthroid)", details: "Thyroid hormone replacement, used to treat hypothyroidism."),
        Medicine(id: 8, NDC:"0904-6369-61", name: "Amlodipine", details: "Calcium channel blocker, used to treat high blood pressure and angina."),
        Medicine(id: 9, NDC:"37000-455-01", name: "Omeprazole (Prilosec)", details: "Proton pump inhibitor (PPI), reduces stomach acid production, used for acid reflux and ulcers."),
        Medicine(id: 10, NDC:"16729-218-10", name: "Clopidogrel (Plavix)", details: "Antiplatelet medication, helps prevent blood clots."),
        
        Medicine(id: 11, NDC: "0049-0050-01", name: "Sertraline (Zoloft)", details: "Selective serotonin reuptake inhibitor (SSRI), used for treating depression and anxiety."),
        Medicine(id: 12, NDC: "0173-0682-20", name: "Albuterol (Ventolin)", details: "Bronchodilator, used for relieving bronchospasm in conditions like asthma and chronic obstructive pulmonary disease (COPD)."),
        Medicine(id: 13, NDC: "76282-327-01", name: "Warfarin", details: "Anticoagulant (blood thinner), prevents blood clot formation."),
        Medicine(id: 14, NDC: "64125-130-01", name: "Hydrochlorothiazide", details: "Diuretic, used to treat high blood pressure and fluid retention."),
        Medicine(id: 15, NDC: "50419-773-01", name: "Ciprofloxacin", details: "Antibiotic, treats bacterial infections."),
        Medicine(id: 16, NDC: "0777-3104-02", name: "Fluoxetine (Prozac)", details: "SSRI, used for depression, anxiety, and other mood disorders."),
        Medicine(id: 17, NDC: "0140-0004-01", name: "Diazepam (Valium)", details: "Benzodiazepine, used for anxiety, muscle spasms, and seizures."),
        Medicine(id: 18, NDC: "00115-1736-01", name: "Methylphenidate (Ritalin)", details: "Stimulant, used to treat attention deficit hyperactivity disorder (ADHD)."),
        Medicine(id: 19, NDC: "0173-0344-42", name: "Ranitidine (Zantac)", details: "H2 blocker, reduces stomach acid, used for heaartburn and ulcers."),
        Medicine(id: 20, NDC: "0555-0066-02", name: "Isoniazid", details: "Antituberculosis medication, used for treating tuberculosis.")
        
    ]
    
    var body: some View {
        ZStack{
            //background color
            Color(hex:"E7EDEB").ignoresSafeArea()
            List {
                Section(header: Text("Medicine Detail")) {
                    Text("\(parameter ?? "")")
     
                    if let medicine = medicines.first(where: { $0.NDC == parameter}){
                        Text("\(medicine.name)")
                    }
                    if let medicine = medicines.first(where: { $0.NDC == parameter}){
                        Text("\(medicine.details)")
                    }
                    
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
            .navigationTitle("Settings")
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
