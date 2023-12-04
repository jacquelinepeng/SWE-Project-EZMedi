//
//  MedicineDetailView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/4/23.
//

import SwiftUI

struct Medicine: Identifiable {
    let id: Int
    let name: String
    let details: String
}

struct MedicineDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let medicine: Medicine
    @Binding var user: User

    var body: some View {
        ZStack {
            Color(hex: "#E7EDEB").edgesIgnoringSafeArea(.all)

            VStack {
                Text(medicine.details).foregroundColor(Color(hex: "2D9596"))

                Button("Add to My Library") {
                    user.medicineLibrary.append(medicine)
                }
                .padding()
                .background(Color(hex: "2D9596"))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left") // Custom Back Icon
                Text("EZMedi") // Custom Text
            }
            .foregroundColor(Color(hex: "FFFFFF")) // Custom Color
        })
        .navigationBarTitle(medicine.name, displayMode: .inline)
    }
}
