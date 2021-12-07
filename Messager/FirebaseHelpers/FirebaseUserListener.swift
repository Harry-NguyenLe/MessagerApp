//
//  FirebaseUserListener.swift
//  Messager
//
//  Created by Harry Nguyen on 29/11/2021.
//

import Foundation
import Firebase
import CoreMedia
import simd

class FirebaseUserListener{
    static let shared = FirebaseUserListener()
    
    private init() {}
    
    //MARK: Login
    func loginUserWith(email: String, password: String,
                       completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (authDataResult, error) -> Void in
            if error == nil && authDataResult!.user.isEmailVerified {
                FirebaseUserListener.shared.downloadUserFromFirestore(
                    authDataResult!.user.uid,
                    email
                )
                completion(error, true)
            }else {
                print("Cannot sign in, email not verified")
                completion(error, false)
            }
        }
    }
    
    
    
    //MARK: Register
    func registerUserWith(email: String,
                          password: String,
                          completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password){
            (authDataResult, error) in
            completion(error)
            if error == nil {
                //Send verification email
                authDataResult!.user.sendEmailVerification {
                    (error) in
                    if error != nil {
                        print("authen email send with error: ", error!.localizedDescription)
                    }
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
                    saveUserLocally(user)
                    self.saveUserToFirestore(user)
                }
            }
        }
    }
    
    //MARK: Save users to Firestore
    func saveUserToFirestore(_ user: User) {
        do {
            /**document: In Cloud Firestore, the unit of storage is the document.
             **/
            try firebaseReference(.User).document(user.id).setData(from: user)
        }catch {
            print(error.localizedDescription, "adding user")
        }
        
    }
    
    //MARK: Download user from FirebaseFirestore
    func downloadUserFromFirestore(_ userId: String, _ userEmail: String? = nil) {
        firebaseReference(.User).document(userId).getDocument { (querySnapshot, error) in
            /**querySnapshot: contains the results of a query. It can contain zero or more DocumentSnapshot objects.
             **/
            guard let document = querySnapshot else {
                print("There are no document for user")
                return
            }
            
            let result = Result {
                //Decode user from json object to user object
                try? document.data(as: User.self)
            }
            switch result {
                case .success(let userObject):
                    if let user = userObject {
                        saveUserLocally(user)
                    }else {
                        print("Document does not exsist")
                    }
                case .failure(let error):
                    print("Error decoding user: ", error.localizedDescription)
            }
        }
    }
    
    //MARK: Resend email verification
    func resendEmailVerification(email: String,
                                 completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().currentUser?.reload {
            (error) in
            Auth.auth().currentUser?.sendEmailVerification {
                (error) in
                completion(error)
            }
        }
    }
    
    //MARK: Reset password
    func resetPasswordFor(email: String,
                          completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) {
            (error) in
            completion(error)
        }
    }
    
    
}
