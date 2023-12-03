import SwiftUI

// Search Bar View
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        
        //search bar
        HStack{
            TextField("Enter medicine name", text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.leading, 35)
            Image(systemName: "magnifyingglass").font(.system(size: 25))
                .foregroundColor(Color(hex: "#2D9596")).padding().padding(.trailing, 20)
        }
    }
}

// ViewModifier for the Navigation Bar
struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor

    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = backgroundColor

                // Set title color to white
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                if #available(iOS 15.0, *) {
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
            }
    }
}


extension View {
    func navigationBarColor(backgroundColor: UIColor) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
}

// Main SearchView
struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color(hex: "#E7EDEB") // Background color for the whole page
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack (spacing: 5){
                        Spacer()

                        SearchBar(text: $searchText).padding(.bottom, 120)

                        Text("Scan")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#2D9596")).padding(.bottom, 1)

                        Button(action: {
                            // Action for Camera Button
                        }) {
                            Image(systemName: "camera.metering.none") // Camera icon
                                .font(.system(size: 90))
                                .foregroundColor(Color(hex: "#2D9596"))
                        }

                        Spacer()
                    }
                }
                .navigationBarTitle("EZMedi", displayMode: .inline).foregroundColor(.white)
                .navigationBarColor(backgroundColor: UIColor(hex: "#2D9596"))
                .modifier(NavigationBarModifier(backgroundColor: UIColor(hex: "#2D9596"))) // Applying the modifier
            }
        }
    }
}

// Preview provider for SwiftUI previews
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

// Extensions for Color and UIColor with hex initialization
extension Color {
    init(hex: String, alpha: CGFloat = 1.0) {
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
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
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
