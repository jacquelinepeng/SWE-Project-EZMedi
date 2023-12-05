//
//  ProfileView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/3/23.
//

import SwiftUI

struct User_class {
    let uid, email, username: String
    
}

class ProfileViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var user: User_class?
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
                print(data)
                
//                self.errorMessage = "\(String(describing: data["uid"]))"
                
                let uid = data["uid"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let user_name = data["username"] as? String ?? ""
//                let email_short = data["email"]
                print(user_name,"this is the username")
                
//                self.user = User_class(uid: uid, email: email.replaceOccurrences(of: "@gmail.com", with: "") ?? "")
                self.user = User_class(uid: uid, email: email, username: user_name)

//                self.errorMessage = user.uid
        }
        
    }
    
    func handleSignOut(){
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
}




struct ProfileView: View {
    @Binding var user: User
    @State private var showReminderView = false
    @State private var shouldShowLogOutOptions = false
    
    @ObservedObject private var vm = ProfileViewModel()
    
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
                        // Check if the medicine library is empty
                        if user.medicineLibrary.isEmpty {
                            Text("Add Medicine Here").foregroundColor(.gray)
                        } else {
                            // List each medicine
                            ForEach(user.medicineLibrary, id: \.id) { medicine in
                                HStack {
                                    Text(medicine.name)
                                    Spacer()
                                    Button(action: {
                                        showReminderView = true
                                    }, label: {
                                        Text("Set Reminder").foregroundColor(Color(hex: "2D9596"))
                                    })
                                }
                            }.onDelete(perform: deleteMedicine)
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
