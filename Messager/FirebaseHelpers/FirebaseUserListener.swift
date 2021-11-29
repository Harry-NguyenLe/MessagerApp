//
//  FirebaseUserListener.swift
//  Messager
//
//  Created by Harry Nguyen on 29/11/2021.
//

import Foundation
import Firebase

class FirebaseUserListener{
    static let shared = FirebaseUserListener()
    
    private init() {}
    
    //MARK: Login
    
    
    
    //MARK: Register
    func registerUserWith(email: String,
                          password: String,
                          completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password){
            (authDataResult, error) in completion(error)
            if error == nil {
                //Send verification email
                authDataResult!.user.sendEmailVerification {
                    (error) in
                        print("authen email send with error: ", error!.localizedDescription)
                }
                
                //Create user and save it
                if authDataResult?.user != nil {
                     let user = User(
                        id: authDataResult!.user.uid,
                        userName: email,
                        email: email,
                        pushId: "",
                        avatarLink: "",
                        status: "Hey there, i am using Messager"
                     )
                    
                }
            }
        }
    }
}
