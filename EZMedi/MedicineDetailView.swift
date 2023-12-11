//
//  MedicineDetailView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/4/23.
//

import SwiftUI
import FirebaseFirestore


struct Medicine: Identifiable {
    let id: Int
    let NDC: String
    let name: String
    let details: String
    
    
    var toDictionary: [String: Any] {
            return [
                "id": id,
                "name": name,
                "details": details
            ]
        }
}


struct MedicineDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let medicine: Medicine
    @ObservedObject private var vm = ProfileViewModel()
    @State private var showAlert = false
//    @State private var isLoggedIn = false

    var body: some View {
        ZStack {
            Color(hex: "#E7EDEB").edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(medicine.details).foregroundColor(Color(hex: "2D9596"))
                Button("Add to My Library") {
                    if FirebaseManager.shared.isUserLoggedIn() {
                        storeMedicine(medicine_ndc: medicine.NDC)
                    } else {
                        showAlert = true
                        vm.errorMessage = "You need to log in to add medicines to your library."
                    }
                }
                .padding()
                .background(Color(hex: "2D9596"))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            
            .navigationBarTitle(medicine.name, displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Warning"),
                    message: Text(vm.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    private func storeMedicine(medicine_ndc: String) {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid)
            .getDocument { document, error in
                if let error = error {
                    print("\(error)")
                } else if let document = document, document.exists{
                    
                    var updateLibrary: [String] = []
                    
                    if let existingLibrary = document.data()?["medicineLibrary"] as? [String]{
                        updateLibrary = existingLibrary
                        
                        if existingLibrary.contains(medicine_ndc){
                            DispatchQueue.main.async {
                                self.vm.errorMessage = "Medicine already exists in library."
                                self.showAlert = true
                            }
                            return
                        } else {
                            self.vm.errorMessage = "You have successfully update your medicine library."
                            self.showAlert = true
                        }
                    }
                    
                    updateLibrary.append(medicine_ndc)
                    
                    FirebaseManager.shared.firestore.collection("users").document(uid)
                        .setData(["medicineLibrary": updateLibrary], merge:true){ err in
                            if let err = err{
                                print("There is an error: \(err)")
                            } else {
                                print("Medicine stored successfully: \(medicine_ndc)")
                            }
                        }
                    
                } else {
                    FirebaseManager.shared.firestore.collection("users").document(uid)
                        .setData(["medicineLibrary": [medicine_ndc]], merge:true){ err in
                            if let err = err{
                                print(err)
                                return
                            } else {
                                print("Medicine stored successfully: \(medicine_ndc)")
                            }
                        }
                }
                
            }
    }
    
}
