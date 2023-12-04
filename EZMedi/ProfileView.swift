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
                Section(header: Text("User Information")) {
                    Text("Name: \(user.name)")
                    Text("Email: \(user.email)")
                }
                
                Section(header: Text("Medicine Library")) {
                    ForEach(user.medicineLibrary, id: \.id) { medicine in
                        Text(medicine.name)
                            .swipeActions {
                                Button("Reminder") {
                                    // Implement reminder action
                                }
                                .tint(.blue)

                                Button("Delete") {
                                    if let index = user.medicineLibrary.firstIndex(where: { $0.id == medicine.id }) {
                                        user.medicineLibrary.remove(at: index)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationBarTitle("Profile", displayMode: .large)
        }
    }
}

