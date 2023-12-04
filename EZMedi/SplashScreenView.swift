//
//  SplashScreenView.swift
//  EZMedi
//
//  Created by Qinomi on 3/12/2023.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive{
            MainView()
        } else{
            VStack{
                VStack{
                    VStack{
                        Text("EZMedi")
                            .font(.system(size: 40))
                            .foregroundColor(Color(hex:"2D9596"))
                            .bold().padding([.top, .leading, .trailing])
                        Image("EZMedi_Splash")
                            .resizable()
                            .padding()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear{
                        withAnimation(.easeIn(duration: 1.2)){
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now()+2.0){
                        withAnimation{
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
