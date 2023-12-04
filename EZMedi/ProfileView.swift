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
            ZStack {
                // Set the background color for the entire view
                Color(hex: "#E7EDEB").edgesIgnoringSafeArea(.all)

                // The List with clear background
                List {
                    Section(header: Text("User Information").font(.headline).foregroundColor((Color(hex:"2D9596")))) {
                        Text("Name: \(user.name)")
                        Text("Email: \(user.email)")
                    }

                    Section(header: Text("Medicine Library").font(.headline).foregroundColor((Color(hex:"2D9596")))) {
                        ForEach(user.medicineLibrary, id: \.id) { medicine in
                            Text(medicine.name)
                        }.onDelete(perform: deleteMedicine)
                        
                        if user.medicineLibrary.isEmpty {
                            Text("Add Medicine Here").foregroundColor(.gray)
                        }
                    }
                }.listStyle(.plain)
            }
            .navigationBarTitle("Profile", displayMode: .large)
        }
    }

    private func deleteMedicine(at offsets: IndexSet) {
        user.medicineLibrary.remove(atOffsets: offsets)
    }
}


//User Class
struct User {
    var name: String
    var email: String
    var medicineLibrary: [Medicine]
}
