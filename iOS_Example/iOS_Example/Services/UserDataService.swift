//
//  UserDataService.swift
//  LazyList-SwiftUI
//
//  Created by Kalpesh on 17/05/24.
//

import Foundation

public class UserDataService {
    public static func users()->[UserModel] {
        return [
            UserModel(id: 1, name: "Joy", email: "joy42@gmail.com", phone: "9929966149", address: "Alaska"),
            UserModel(id: 2, name: "Lee", email: "leeCupper@gmail.com", phone: "9923764576", address: "Georgea"),
            UserModel(id: 3, name: "Bob", email: "BobChrist@gmail.com", phone: "5762347643", address: "London"),
            UserModel(id: 4, name: "Maria", email: "MariaEspinoza@gmail.com", phone: "2346533732", address: "LosAngeles"),
            UserModel(id: 5, name: "Lara", email: "Lara234@gmail.com", phone: "5653463637", address: "Gandhinagar"),
            UserModel(id: 6, name: "John", email: "JohnSen@gmail.com", phone: "4056443267", address: "Mumbai"),
            UserModel(id: 7, name: "Jessy", email: "Jessy1990@gmail.com", phone: "5819896364", address: "Fransisco"),
            UserModel(id: 8, name: "Ronaldo", email: "ronaldo@gmail.com", phone: "9929966149", address: "Alaska"),
            UserModel(id: 9, name: "Messy", email: "messy@gmail.com", phone: "9923764576", address: "Georgea"),
            UserModel(id: 10, name: "Roy", email: "roy4034@gmail.com", phone: "5762347643", address: "London"),
            UserModel(id: 11, name: "Harish", email: "harishv23@gmail.com", phone: "2346533732", address: "LosAngeles"),
            UserModel(id: 12, name: "meera", email: "meera@gmail.com", phone: "5653463637", address: "Gandhinagar"),
            UserModel(id: 13, name: "Hudson", email: "HMeloy@gmail.com", phone: "4056443267", address: "Mumbai"),
            UserModel(id: 14, name: "Nicolus", email: "NicMerry@gmail.com", phone: "5819896364", address: "Fransisco")
        ]
    }
}
