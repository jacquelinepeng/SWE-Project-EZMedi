//
//  ContentView.swift
//  EZMedi
//
//  Created by dhzy on 2023/11/27.
//
import SwiftUI

struct NavigationBarModifier: UIViewControllerRepresentable {
    var backgroundColor: UIColor

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationBarModifier>) -> UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationBarModifier>) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Optional: Change title color

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension UIColor {
   convenience init(hex: String) {
       var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
       hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

       var rgb: UInt64 = 0

       Scanner(string: hexSanitized).scanHexInt64(&rgb)

       let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
       let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
       let blue = CGFloat(rgb & 0x0000FF) / 255.0

       self.init(red: red, green: green, blue: blue, alpha: 1.0)
   }
}

struct SearchView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Your content here
                Color(hex: "E7EDEB") // Background color for the whole page
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationBarTitle("EZMedi", displayMode: .inline)
            .background(NavigationBarModifier(backgroundColor: UIColor(hex: "#2D9596")))
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
