//
//  LoginView.swift
//  EZMedi
//
//  Created by Qinomi on 4/12/2023.
//

import SwiftUI
import Firebase


struct LoginPage: View {
    
    let didCompleteLoginProcess: () -> ()


    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Welcome to EZMedi!")
                    .font(.system(size: 36))
                    .foregroundColor(Color(hex:"2D9596"))
                    .padding(.bottom, 50)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                Button{
                    // Perform login action
                    handleAction()
                } label: {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color(hex:"2D9596"))
                        .cornerRadius(25.0)
                }
                
                Text(self.LoginStatusMessage).foregroundColor(.red)
                Spacer()

                NavigationLink(destination: RegisterPage()) {
                    HStack{
                        Text("Don't have an account? ")
                            .foregroundColor(.black)
                        Text("Register")
                            .foregroundColor(Color(hex:"2D9596"))
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: MainView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                
            }
            .padding()
            .background(Color(hex: "##E7EDEB"))
            .ignoresSafeArea()
        }
    }
    
    private func handleAction(){
        print("Login")
        loginUser()
    }
    
    @State var LoginStatusMessage = ""
    
    private func loginUser(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result, err in
            if let err = err {
                print("Failed to login:", err)
                self.LoginStatusMessage = "Failed to login: \(err)"
                return
            }
            print("successfully login as user: \(result?.user.uid ?? "")")
            self.LoginStatusMessage = "successfully login as user: \(result?.user.uid ?? "")"
            isLoggedIn = false
            
            self.didCompleteLoginProcess()
        }
    }
}


struct RegisterPage: View {
    // Registration view content goes here
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            Text("Sign up")
                .font(.system(size: 36))
                .foregroundColor(Color(hex:"2D9596"))
                .padding(.bottom, 50)
            
            TextField("User name", text: $username)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            TextField("Email address", text: $email)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            
            Button(action: {
                handleAction()
            }) {
                Text("Sign up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color(hex:"2D9596"))
                    .cornerRadius(25.0)
            }
            
            Text(self.LoginStatusMessage).foregroundColor(.red)
            
            Spacer()
            Spacer()
            
        }
        .padding()
        .background(Color(hex: "##E7EDEB"))
        .ignoresSafeArea()
    }
    private func handleAction(){
        print("Here start the register")
        createNewAccount()
    }
    
    @State var LoginStatusMessage = ""
    
    private func createNewAccount(){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password){
            result, err in
            if let err = err{
                print("Failed to create user!", err)
                self.LoginStatusMessage = "Failed to create user!: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.LoginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            self.storeUserInformation()
        }
    }
    
    private func storeUserInformation(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            return
        }
        
        print(uid,"this is uid")
        
        let userData = ["email": self.email, "uid": uid, "username": self.username]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData){
                err in
                if let err = err{
                    print(err)
                    self.LoginStatusMessage = "\(err)"
                    return
                }
                print("You have Successfully save your account!")
            }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage(didCompleteLoginProcess: {
            
        })
    }
}
