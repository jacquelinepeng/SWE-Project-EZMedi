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
        CustomTabBarView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
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
    @State private var user = User(name: "Sample User", email: "sample@email.com", medicineLibrary: [])

    func makeUIViewController(context: Context) -> UIViewController {
        let customTabBarController = CustomTabBarController()

        let searchVC = UIHostingController(rootView: SearchView(user: $user))
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let profileVC = UIHostingController(rootView: ProfileView(user: $user))
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 1)

        customTabBarController.viewControllers = [searchVC, profileVC]

        return customTabBarController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
