//
//  DatabaseUser.swift
// This is the database model for our user accounts
//
//  Created by mikaila Akeredolu on 7/14/25.
//

import Foundation

struct DatabaseUser: Codable {
    
    let userID: String?
    let username: String?
    let email: String?
    let dateCreated: Date
    
}

extension DateFormatter {
    static let userFriendlyDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
