//
//  MainView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/3/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        TabView{
            
            SearchView().tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            ProfileView().tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

#Preview {
    MainView()
}
