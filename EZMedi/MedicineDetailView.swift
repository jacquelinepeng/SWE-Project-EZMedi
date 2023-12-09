//
//  MedicineDetailView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/4/23.
//

import SwiftUI



struct MedicineDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let medicine: Medicine
    @ObservedObject private var vm = ProfileViewModel()
//    @Binding var user: User

    var body: some View {
        ZStack {
            Color(hex: "#E7EDEB").edgesIgnoringSafeArea(.all)

            VStack {
                Text(medicine.details).foregroundColor(Color(hex: "2D9596"))

                Button("Add to My Library") {
                    vm.user?.medicineLibrary.append(medicine)
                    print(vm.user ?? ["test"])
                }
                .padding()
                .background(Color(hex: "2D9596"))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarTitle(medicine.name, displayMode: .inline)
    }
}

