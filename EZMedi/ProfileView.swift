//
//  ProfileView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/3/23.
//

import SwiftUI

struct ProfileView: View {
    @Binding var user: User

    var body: some View {
        NavigationView {
            List {
                // User Information Section
                Section(header: Text("User Information")) {
                    Text("Name: \(user.name)")
                    Text("Email: \(user.email)")
                }

                // Medicine Library Section
                Section(header: Text("Medicine Library")) {
                    ForEach(user.medicineLibrary, id: \.id) { medicine in
                        HStack {
                            Text(medicine.name)
                            Spacer()
                            Button("Set Reminder") {
                                // Implement reminder action here
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .onDelete(perform: deleteMedicine)
                }
            }
            .navigationBarTitle("Profile", displayMode: .large)
        }
    }

    private func deleteMedicine(at offsets: IndexSet) {
        user.medicineLibrary.remove(atOffsets: offsets)
    }
}

struct User {
    var name: String
    var email: String
    var medicineLibrary: [Medicine]
}
