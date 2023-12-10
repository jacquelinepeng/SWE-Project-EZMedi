//
//  ProfileView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/3/23.
//

import SwiftUI

struct User_class {
    let uid, email: String
    var username: String
    var medicineLibrary: [String]
}



class ProfileViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var user: User_class?
    @Published var medicine: Medicine?
    @Published var isUserCurrentlyLoggedOut = false
    
    init(){
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut =
                FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
    }
    
    func fetchCurrentUser(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
        else{
            self.errorMessage = "Cound't find user!"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { (email, error) in
                if let error = error {
                    self.errorMessage = "Failed to fetch current user: \(error)"
                    print("Failed to Fetch current email:",error)
                    return
                }
            
                guard let data = email?.data() else {
                    self.errorMessage = "No Data found"
                    return }
                
                
//                self.errorMessage = "\(String(describing: data["uid"]))"
                
                let uid = data["uid"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let user_name = data["username"] as? String ?? ""
                let medicineLibrary = data["medicineLibrary"] as? [String] ?? []
//                let email_short = data["email"]
                print(medicineLibrary,"this is the lib")
                
//                self.user = User_class(uid: uid, email: email.replaceOccurrences(of: "@gmail.com", with: "") ?? "")
                self.user = User_class(uid: uid, email: email, username: user_name, medicineLibrary: medicineLibrary)
                print(self.user ?? ["none"])

//                self.errorMessage = user.uid
        }
        
    }
    
    func deleteMedicine(at offsets: IndexSet) {
        // Check if user and medicineLibrary are not nil
        
        var medicineLibraryArray = self.user?.medicineLibrary ?? []
        
        // Remove items at specified offsets
        medicineLibraryArray.remove(atOffsets: offsets)
        print("this is function delete`medicine")
        print(medicineLibraryArray)
    }
    
    func handleSignOut(){
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
}




struct ProfileView: View {
//    @Binding var user: User
    @ObservedObject private var vm = ProfileViewModel()
    @State private var showReminderView = false
    @State private var shouldShowLogOutOptions = false
    
    

    var body: some View {
        
        NavigationView {
            
            ZStack {
                // Set the background color for the entire view
                Color(hex: "#E7EDEB").edgesIgnoringSafeArea(.all)
                
                
                // The List with clear background
                List {
                    // User Information Section
                    Section(header: Text("User Information").font(.headline).foregroundColor(Color(hex:"2D9596"))) {
                        Text("Name: \(vm.user?.username ?? "")")
                        Text("Email: \(vm.user?.email ?? "")")
                    }
                    
                    // Medicine Library Section
                    Section(header: Text("Medicine Library").font(.headline).foregroundColor(Color(hex:"2D9596"))) {
                        var medicineLibraryArray = vm.user?.medicineLibrary ?? []
                        
                        if (medicineLibraryArray.isEmpty){
                            Text("Add Medicine Here").foregroundColor(.gray)
                            //                            Text("Add Medicine Here \(vm.user?.medicineLibrary.isEmpty)")
                        } else {
                            // List each medicine
//                            let medicineLibraryArray = vm.user?.medicineLibrary ?? ["nothing"]
//                            Text("this is not empty")
                            //                            Text("test name \(vm.user?.medicineLibrary ?? ["nothing"])")
                            ForEach(medicineLibraryArray, id: \.self) { medicine_ndc in
                                
                                HStack {
                                    Text(medicine_ndc)
                                    Spacer()
                                    Button(action: {
                                        showReminderView = true
                                    }, label: {
                                        Text("Set Reminder").foregroundColor(Color(hex: "2D9596")).padding(.trailing)
                                    })
                                }
                            }
                            .onDelete(perform: vm.deleteMedicine)
                            .navigationTitle("example")
                            .background(NavigationLink("", destination: ReminderView(), isActive: $showReminderView))
                        }
                        
                    }
                    
                }
                .listStyle(.plain)
                
                
                
            }
            .navigationBarTitle("Profile", displayMode: .large)
            
            .navigationBarItems(trailing:
                                    Button{
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 40, height: 40)
                    .background(Color(hex:"2D9596"))
                    .cornerRadius(25.0)
            }
            )
            .actionSheet(isPresented: $shouldShowLogOutOptions){
                .init(title: Text("Settings"), message: Text("What do you want to do?"),
                      buttons: [ .destructive(Text("Sign out"), action:{
                    print("Handle sign out")
                    vm.handleSignOut()
                }),
                                 .cancel()
                               ])
            }
            .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss:nil){
                LoginPage(didCompleteLoginProcess: {
                    self.vm.isUserCurrentlyLoggedOut = false
                    self.vm.fetchCurrentUser()
                })
            }
        }
    }
//
//    
//    private func deleteMedicine(at offsets: IndexSet) {
//        user.medicineLibrary.remove(atOffsets: offsets)
//    }
//    

}

//
//struct User {
//    var name: String
//    var email: String
//    var medicineLibrary: [Medicine]
//}
