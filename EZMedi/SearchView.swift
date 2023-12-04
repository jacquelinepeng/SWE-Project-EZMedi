import SwiftUI

struct Medicine: Identifiable {
    let id: Int
    let name: String
    let details: String
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack{
            TextField("Enter medicine name", text: $text)
                .foregroundColor(.black)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.leading, 35)
            Image(systemName: "magnifyingglass").font(.system(size: 25)).foregroundColor(Color(hex: "#2D9596")).padding().padding(.trailing, 20)
                }

    }
}

struct MedicineDetailView: View {
    let medicine: Medicine
    @Binding var user: User

    var body: some View {
        ZStack {
            // Set the background color for the entire view
            Color(hex: "#E7EDEB").edgesIgnoringSafeArea(.all)

            VStack {
                Text(medicine.details)
                    .foregroundColor(Color(hex: "265073"))
                
                Button("Add to My Library") {
                    user.medicineLibrary.append(medicine)
                }
                .padding()
                .background(Color(hex: "265073"))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding() // Add some padding around the VStack content
        }
        .navigationBarTitle(medicine.name, displayMode: .inline)
    }
}


struct SearchView: View {
    @State private var searchText = ""
    @State private var isScannerPresented = false
    @State private var scannedCode: String?
    @State private var isSearchActive = false
    @Binding var user: User

    let medicines = [
        Medicine(id: 1, name: "Aspirin", details: "Used to reduce pain, fever, or inflammation."),
        Medicine(id: 2, name: "Ibuprofen", details: "It's used for pain relief and reducing inflammation."),
        // Add more medicines
    ]

    var filteredMedicines: [Medicine] {
        if searchText.isEmpty {
            return medicines
        } else {
            return medicines.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#E7EDEB").edgesIgnoringSafeArea(.all)

                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if isSearchActive || !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                isSearchActive = false
                                hideKeyboard()
                            }) {
                                Image(systemName: "arrow.backward")
                                    .foregroundColor(Color(hex: "#2D9596"))
                            }
                            .padding(.leading, 20)
                        }

                        SearchBar(text: $searchText, isEditing: $isSearchActive)
                    }
                    .padding(.vertical)

                    if isSearchActive || !searchText.isEmpty {
                        List(filteredMedicines, id: \.id) { medicine in
                            NavigationLink(destination: MedicineDetailView(medicine: medicine, user: $user)) {
                                Text(medicine.name)
                                    .foregroundColor(.black)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color(hex: "#E7EDEB"))
                    } else {
                        Spacer()

                        Text("Scan")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#2D9596"))
                            .padding(.bottom, 1)
                        
                        Button(action: {
                            isScannerPresented = true
                        }) {
                            Image(systemName: "camera.metering.none")
                                .font(.system(size: 90))
                                .foregroundColor(Color(hex: "#2D9596"))
                        }
                        .sheet(isPresented: $isScannerPresented) {
                            BarcodeScannerView(isPresented: $isScannerPresented, scannedCode: $scannedCode)
                        }

                        if let scannedCode = scannedCode {
                            Text("Scanned: \(scannedCode)")
                                .padding(.top)
                                .foregroundColor(Color(hex: "#2D9596"))
                        }

                        Spacer()
                    }
                }
            }
            .navigationBarTitle("EZMedi", displayMode: .inline)
            .navigationBarColor(backgroundColor: UIColor(hex: "#2D9596"))
            .modifier(NavigationBarModifier(backgroundColor: UIColor(hex: "#2D9596")))
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
