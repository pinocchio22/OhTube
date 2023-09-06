//
//  DataManager.swift
//  OhTube
//
//  Created by playhong on 2023/09/04.
//

import UIKit

final class DataManager {
    static let shared = DataManager()
    private let userDefaults = UserDefaults.standard
    private let userListKey = "UserList"
    typealias UserList = [User]
    
    private init() {}
    
    func getUserList() -> [User] {
        if let encodedUserList = self.userDefaults.object(forKey: userListKey) as? Data,
           let userList = try? JSONDecoder().decode(UserList.self, from: encodedUserList) {
            return userList
        }
        return []
    }
    
    private func updateUserDefaults(_ userList: UserList) {
        if let encodedUserList = try? JSONEncoder().encode(userList) {
            self.userDefaults.set(encodedUserList, forKey: userListKey)
        }
    }
    
    func createUser(_ user: User) {
        var userList = getUserList()
        userList.append(user)
        updateUserDefaults(userList)
    }
}
