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
    let medicine: Medicine
    @Binding var user: User

    var body: some View {
        ZStack {
            // Set the background color for the entire view
            Color(hex: "#E7EDEB").edgesIgnoringSafeArea(.all)

            VStack {
                Text(medicine.details)
                    .foregroundColor(Color(hex: "265073"))
                
                Button("Add to My Library") {
                    user.medicineLibrary.append(medicine)
                }
                .padding()
                .background(Color(hex: "265073"))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding() // Add some padding around the VStack content
        }
        .navigationBarTitle(medicine.name, displayMode: .inline)
    }
}
