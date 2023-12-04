//
//  ProfileView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/3/23.
//

import SwiftUI

struct ProfileView: View {
    @State var user: User

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
                    }
                }
            }
            .navigationBarTitle("Profile", displayMode: .large)
        }
    }
}

struct User {
    var name: String
    var email: String
    var medicineLibrary: [Medicine]
}
