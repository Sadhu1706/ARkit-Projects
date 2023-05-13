//
//  Firestore_demoApp.swift
//  Firestore demo
//
//  Created by Sadhun Arun on 29/11/22.
//

import SwiftUI
import Firebase

@main
struct Firestore_demoApp: App {		
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
