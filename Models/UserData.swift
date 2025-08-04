//
//  UserData.swift
//  FireFetch
//
//  Created by mikaila Akeredolu on 7/13/25.
//
//This USerData is just for Authentication ONLY not the actual user in DB

import Foundation
import FirebaseAuth //gets us access to a Firebase User class/object

struct UserData{
    
    let uid: String
    let email: String? //optional email is returned by firebabse
    
    init(user: User) { //Type User if from Firebase User
        self.uid = user.uid
        self.email = user.email
    }
    
}
