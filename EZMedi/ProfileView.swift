//
//  ProfileView.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/3/23.
//

import SwiftUI

struct User_class {
    let uid, email: String
    var username: String
    var medicineLibrary: [String]
}



class ProfileViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var user: User_class?
    @Published var medicine: Medicine?
    @Published var isUserCurrentlyLoggedOut = false
    
    init(){
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut =
                FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
    }
    
    func fetchCurrentUser(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
        else{
            self.errorMessage = "User does not exist."
            return
        }
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { (email, error) in
                if let error = error {
                    self.errorMessage = "Failed to fetch current user: \(error)"
                    print("Failed to Fetch current email:",error)
                    return
                }
            
                guard let data = email?.data() else {
                    self.errorMessage = "No Data found"
                    return }
                
                
//                self.errorMessage = "\(String(describing: data["uid"]))"
                
                let uid = data["uid"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let user_name = data["username"] as? String ?? ""
                let medicineLibrary = data["medicineLibrary"] as? [String] ?? []
//                let email_short = data["email"]
                print(medicineLibrary,"this is the lib")
                
//                self.user = User_class(uid: uid, email: email.replaceOccurrences(of: "@gmail.com", with: "") ?? "")
                self.user = User_class(uid: uid, email: email, username: user_name, medicineLibrary: medicineLibrary)
                print(self.user ?? ["none"])
                
                DispatchQueue.main.async {
                    self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser == nil
                }
//                self.errorMessage = user.uid
        }
        
    }
    
    func deleteMedicine(at offsets: IndexSet) {
        // Check if user and medicineLibrary are not nil
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "User not found"
            return
        }
        
        var medicineLibraryArray = self.user?.medicineLibrary ?? []
        
        // Remove items at specified offsets
        medicineLibraryArray.remove(atOffsets: offsets)
        
        FirebaseManager.shared.firestore.collection("users").document(uid)
                .updateData(["medicineLibrary": medicineLibraryArray]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                        self.errorMessage = "Error updating document: \(err)"
                    } else {
                        print("Library successfully updated")
                        // Update the local user data
                        self.user?.medicineLibrary = medicineLibraryArray
                    }
                }
        
//        print("this is function delete`medicine")
    }
    
    func handleLogin(){
        isUserCurrentlyLoggedOut = false
        fetchCurrentUser()
    }
    
    func handleSignOut(){
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
}

struct ProfileView: View {
//    @Binding var user: User
    @ObservedObject private var vm = ProfileViewModel()
    @State private var showReminderView = false
    @State private var shouldShowLogOutOptions = false
    @State private var selectedMedicine: String? = nil
    
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
    
    

    var body: some View {
        
        NavigationView {
            
            ZStack {
                // Set the background color for the entire view
                Color(hex: "#E7EDEB").edgesIgnoringSafeArea(.all)
                
                
                // The List with clear background
                List {
                    // User Information Section
                    Section(header: Text("User Information").font(.headline).foregroundColor(Color(hex:"2D9596"))) {
                        Text("Name: \(vm.user?.username ?? "")")
                        Text("Email: \(vm.user?.email ?? "")")
                    }
                    
                    // Medicine Library Section
                    Section(header: Text("Medicine Library").font(.headline).foregroundColor(Color(hex:"2D9596"))) {
                        let medicineLibraryArray = vm.user?.medicineLibrary ?? []
                        
                        if (medicineLibraryArray.isEmpty){
                            Text("Add Medicine Here").foregroundColor(.gray)
                            //                            Text("Add Medicine Here \(vm.user?.medicineLibrary.isEmpty)")
                        } else {
                            // List each medicine
//                            let medicineLibraryArray = vm.user?.medicineLibrary ?? ["nothing"]
//                            Text("this is not empty")
                            //                            Text("test name \(vm.user?.medicineLibrary ?? ["nothing"])")
                            ForEach(medicineLibraryArray, id: \.self) { medicine_ndc in
                                
                                HStack {
//                                    Text(medicine_ndc)
                                    if let medicine = medicines.first(where: { $0.NDC == medicine_ndc}){
                                        Text("\(medicine.name)")
                                    }
                                    Spacer()
                                    Button(action: {
                                        selectedMedicine = medicine_ndc
                                        showReminderView = true
                                    }, label: {
                                        Text("Set Reminder").foregroundColor(Color(hex: "2D9596")).padding(.trailing)
                                    })
                                }
                            }
                            .onDelete(perform: vm.deleteMedicine)
                            .navigationTitle("Profile")
                            .background(NavigationLink("", destination: ReminderView(parameter: selectedMedicine), isActive: $showReminderView))
                        }
                        
                    }
                    
                }
                .onAppear(perform: vm.fetchCurrentUser)
                .listStyle(.plain)
                
                
                
            }
            .navigationBarTitle("Profile", displayMode: .large)
            
            .navigationBarItems(trailing:
                                    Button{
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 40, height: 40)
                    .background(Color(hex:"2D9596"))
                    .cornerRadius(25.0)
            }
            )
            .actionSheet(isPresented: $shouldShowLogOutOptions){
                .init(title: Text("Settings"), message: Text("What do you want to do?"),
                      buttons: [ .destructive(Text("Sign out"), action:{
                    print("Handle sign out")
                    vm.handleSignOut()
                }),
                                 .cancel()
                               ])
            }
            .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss:nil){
                LoginPage(didCompleteLoginProcess: {
                    vm.handleLogin()
                })
            }
        }
    }
//
//
//    private func deleteMedicine(at offsets: IndexSet) {
//        user.medicineLibrary.remove(atOffsets: offsets)
//    }
//

}

//
//struct User {
//    var name: String
//    var email: String
//    var medicineLibrary: [Medicine]
//}
