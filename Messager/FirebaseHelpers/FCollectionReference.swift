//
//  CollectionReference.swift
//  Messager
//
//  Created by Harry Nguyen on 29/11/2021.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Recent
}

func firebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(
        collectionReference.rawValue
    )
}
