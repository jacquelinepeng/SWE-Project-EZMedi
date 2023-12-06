//
//  MainView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/3/23.
//

import SwiftUI
import UIKit

struct MainView: View {
    var body: some View {
        NavigationView {
            CustomTabBarView().edgesIgnoringSafeArea(.all)
//                .navigationBarTitle("EZMedi", displayMode: .inline)
                }
            
    }
}

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the UITabBar appearance
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(hex: "#A2C8C8") //background color of toolbar
        tabBar.standardAppearance = appearance
        
        //toolbar icon color
        tabBar.tintColor = UIColor(hex: "#2D9596")
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
}

struct CustomTabBarView: UIViewControllerRepresentable {
    @ObservedObject private var vm = ProfileViewModel()
    @State private var user = User(name: "Sample User", email: "sample@email.com", medicineLibrary: [])

    func makeUIViewController(context: Context) -> UIViewController {
        let customTabBarController = CustomTabBarController()

        let searchVC = UIHostingController(rootView: SearchView(user: $user))
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let profileVC = UIHostingController(rootView: ProfileView())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 1)

        customTabBarController.viewControllers = [searchVC, profileVC]
        
        return customTabBarController

    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

//    .navigationBarColor(backgroundColor: UIColor(hex: "#2D9596"))
//    .modifier(NavigationBarModifier(backgroundColor: UIColor(hex: "#2D9596")))


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
