//
//  LoginView.swift
//  EZMedi
//
//  Created by Qinomi on 4/12/2023.
//

import SwiftUI

struct LoginPage: View {
    @State private var username: String = ""
    @State private var password: String = ""
    var isSecurity = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Welcome to EZMedi!")
                    .font(.system(size: 36))
                    .foregroundColor(Color(hex:"2D9596"))
                    .padding(.bottom, 50)
        

                TextField("Username", text: $username)
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
                    // Perform login action
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color(hex:"2D9596"))
                        .cornerRadius(25.0)
                }

                Spacer()

                NavigationLink(destination: RegisterPage()) {
                    HStack{
                        Text("Don't have an account? ")
                            .foregroundColor(.black)
                        Text("Sign up")
                            .foregroundColor(Color(hex:"2D9596"))
                    }
                }
                
                Spacer()
                
            }
            .padding()
            .background(Color(hex: "##E7EDEB"))
            .ignoresSafeArea()
        }
    }
}


struct RegisterPage: View {
    // Registration view content goes here
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var password_2: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            Text("Sign up")
                .font(.system(size: 36))
                .foregroundColor(Color(hex:"2D9596"))
                .padding(.bottom, 50)
            
            TextField("Email address", text: $username)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            SecureField("Enter password again", text: $password_2)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button(action: {
                // Perform login action
            }) {
                Text("Sign up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color(hex:"2D9596"))
                    .cornerRadius(25.0)
            }
            
            Spacer()
            Spacer()
            
        }
        .padding()
        .background(Color(hex: "##E7EDEB"))
        .ignoresSafeArea()
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
