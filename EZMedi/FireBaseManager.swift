//
//  FireBaseManager.swift
//  EZMedi
//
//  Created by Jiangweilin Peng on 12/4/23.
//

import Foundation
import Firebase

class FirebaseManager: NSObject{
    
    let auth: Auth
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    override init(){
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
    func isUserLoggedIn() -> Bool {
        return auth.currentUser != nil
    }
}
