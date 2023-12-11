import SwiftUI

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


struct SearchView: View {
    @State private var searchText = ""
    @State private var isScannerPresented = false
    @State private var isSearchActive = false
    
    @State private var scannedCode: String?
    @State private var showMedicineDetail = false
    @State private var selectedMedicine: Medicine?
    @State private var showError = false
    @State private var navigateToDetail = false

//    @Binding var user: User

    public let medicines = [
        Medicine(id: 1, NDC:"0363-0587-14", name: "Aspirin", details: "Used to reduce pain, fever, or inflammation."),
        Medicine(id: 2, NDC:"0904-5853-40", name: "Ibuprofen", details: "It's used for pain relief and reducing inflammation."),
        Medicine(id: 3, NDC:"50580-600-01", name: "Acetaminophen(Tylenol)", details: "Pain relief, fever reduction, not anti-inflammatory."),
        Medicine(id: 4, NDC:"0591-0405-01", name: "Lisinopril", details: "Angiotensin-converting enzyme (ACE) inhibitor used to treat hypertension."),
        Medicine(id: 5, NDC:"60429-111-01", name: "Metformin", details: "Antidiabetic medication, helps control blood sugar levels in type 2 diabetes."),
        Medicine(id: 6, NDC:"0378-3953-77", name: "Atorvastatin (Lipitor)", details: "Effect: Statin medication, lowers cholesterol levels."),
        Medicine(id: 7, NDC:"51079-443-20", name: "Levothyroxine (Synthroid)", details: "Thyroid hormone replacement, used to treat hypothyroidism."),
        Medicine(id: 8, NDC:"0904-6369-61", name: "Amlodipine", details: "Calcium channel blocker, used to treat high blood pressure and angina."),
        Medicine(id: 9, NDC:"37000-455-01", name: "Omeprazole (Prilosec)", details: "Proton pump inhibitor (PPI), reduces stomach acid production, used for acid reflux and ulcers."),
        Medicine(id: 10, NDC:"16729-218-10", name: "Clopidogrel (Plavix)", details: "Antiplatelet medication, helps prevent blood clots."),
        
        Medicine(id: 11, NDC: "0049-0050-01", name: "Sertraline (Zoloft)", details: "Selective serotonin reuptake inhibitor (SSRI), used for treating depression and anxiety."),
        Medicine(id: 12, NDC: "0173-0682-20", name: "Albuterol (Ventolin)", details: "Bronchodilator, used for relieving bronchospasm in conditions like asthma and chronic obstructive pulmonary disease (COPD)."),
        Medicine(id: 13, NDC: "76282-327-01", name: "Warfarin", details: "Anticoagulant (blood thinner), prevents blood clot formation."),
        Medicine(id: 14, NDC: "64125-130-01", name: "Hydrochlorothiazide", details: "Diuretic, used to treat high blood pressure and fluid retention."),
        Medicine(id: 15, NDC: "50419-773-01", name: "Ciprofloxacin", details: "Antibiotic, treats bacterial infections."),
        Medicine(id: 16, NDC: "0777-3104-02", name: "Fluoxetine (Prozac)", details: "SSRI, used for depression, anxiety, and other mood disorders."),
        Medicine(id: 17, NDC: "0140-0004-01", name: "Diazepam (Valium)", details: "Benzodiazepine, used for anxiety, muscle spasms, and seizures."),
        Medicine(id: 18, NDC: "00115-1736-01", name: "Methylphenidate (Ritalin)", details: "Stimulant, used to treat attention deficit hyperactivity disorder (ADHD)."),
        Medicine(id: 19, NDC: "0173-0344-42", name: "Ranitidine (Zantac)", details: "H2 blocker, reduces stomach acid, used for heartburn and ulcers."),
        Medicine(id: 20, NDC: "0555-0066-02", name: "Isoniazid", details: "Antituberculosis medication, used for treating tuberculosis.")
        
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
                
                NavigationLink(destination: MedicineDetailView(medicine: selectedMedicine ?? Medicine(id: 0, NDC: "", name: "", details: "")),
                               isActive: $navigateToDetail) {
                    EmptyView()
                }.hidden()
                
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
                            NavigationLink(destination: MedicineDetailView(medicine: medicine)) {
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
                            BarcodeScannerView(isPresented: $isScannerPresented, scannedCode: $scannedCode).onDisappear{self.scannedCode = nil}
                        }
                        
                        .onChange(of: scannedCode) { newValue in
                            if let code = newValue {
                                if let medicine = medicines.first(where: { $0.NDC == code }) {
                                    self.selectedMedicine = medicine
                                    self.navigateToDetail = true
                                    self.scannedCode = nil
                                }
                                else {
                                    self.showError = true
                                }
                            }
                        }
                        .sheet(isPresented: $showMedicineDetail) {
                            if let medicine = selectedMedicine {
                                MedicineDetailView(medicine: medicine)
                            }
                        }
                        .alert(isPresented: $showError) {
                            Alert(title: Text("Error"), message: Text("Scanned code not found"), dismissButton: .default(Text("OK")))
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
