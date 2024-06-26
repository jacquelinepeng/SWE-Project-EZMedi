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
                self.LoginStatusMessage = errorMessage(err)
//                print("Firebase error code:", (err as NSError).code)

                return
            }
            print("successfully login as user: \(result?.user.uid ?? "")")
            self.LoginStatusMessage = "successfully login as user: \(result?.user.uid ?? "")"
            isLoggedIn = false
            
            self.didCompleteLoginProcess()
        }
    }
}

private func errorMessage(_ error: Error) -> String {
    let errorCode = (error as NSError).code
    switch errorCode {
    case AuthErrorCode.invalidEmail.rawValue:
        return "Invalid email address."
    case AuthErrorCode.emailAlreadyInUse.rawValue:
        return "This email is already in use."
    case AuthErrorCode.wrongPassword.rawValue:
        return "Incorrect password."
    case AuthErrorCode.userNotFound.rawValue:
        return "User does not exist."
    case AuthErrorCode.missingEmail.rawValue:
        return "No user record found for the given email."
    case AuthErrorCode.tooManyRequests.rawValue:
        return "Attempted too many times, please try later."
    case AuthErrorCode.weakPassword.rawValue:
        return "Password too weak."
    case AuthErrorCode.wrongPassword.rawValue:
        return "Incorrect password."
    default:
        return "An unexpected error occurred."
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
            
            TextField("Username", text: $username)
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
    
    private func createNewAccount (){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password){
            result, err in
            if let err = err {
                print("Failed to create user!", err)
                self.LoginStatusMessage = errorMessage(err)
//                self.LoginStatusMessage =  "Failed to create user!: \(err)"
                return
            }
            
//            print("Account created successfully")
            self.LoginStatusMessage = "Account created successfully"
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
