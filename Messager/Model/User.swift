//
//  User.swift
//  Messager
//
//  Created by Harry Nguyen on 29/11/2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Equatable {
    /*
     Codable: Take model object and map it to Firebase
     Equatable: Checking the two models are equal to each other
     */
    var id = ""
    var userName: String
    var email: String
    var pushId = ""
    var avatarLink = ""
    var status: String
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(
                forKey: Contanst.kCURRENTUSER){
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(User.self, from: dictionary)
                    return object
                }catch {
                    print("Error decoding user from user defaults",
                          error.localizedDescription
                    )
                }
            }
        }
        return nil
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
