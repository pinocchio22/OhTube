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
    private let userKey = "User"
    private let isLoginKey = "IsLogin"
    private let userListKey = "UserList"
    private let commentListKey = "CommentList"
    
    typealias UserList = [User]
    typealias CommentList = [Comment]
    
    private init() {}
    
    // MARK: - User
    private func searchUser(_ id: String) -> User {
        let userList = getUserList()
        for user in userList {
            if user.id == id {
                return User(id: user.id, nickName: user.nickName, passWord: user.passWord, likedVideoList: user.likedVideoList)
            }
        }
        return User(id: "", nickName: "", passWord: "")
    }
    
    private func updateUserDefaults(_ user: User) {
        if let encodedUser = try? JSONEncoder().encode(user) {
            self.userDefaults.set(encodedUser, forKey: userKey)
        }
    }
    
    func getUser() -> User? {
        if let encodedUser = self.userDefaults.object(forKey: userKey) as? Data,
           let user = try? JSONDecoder().decode(User.self, from: encodedUser) {
            return user
        }
        return nil
    }
    
    func isLoginState() -> Bool {
        return userDefaults.bool(forKey: isLoginKey)
    }
    
    func saveUser(id: String) {
        let user = searchUser(id)
        updateUserDefaults(user)
    }
    
    func saveIslogin(_ state: Bool) {
        userDefaults.set(state, forKey: isLoginKey)
    }
    
    
    // MARK: - UserList
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
    
    // MARK: - Comment
    func getCommentList() -> [Comment] {
        if let encodedCommentList = self.userDefaults.object(forKey: commentListKey) as? Data,
           let commentList = try? JSONDecoder().decode(CommentList.self, from: encodedCommentList) {
            return commentList
        }
        return []
    }
    
    private func updateUserDefaults(_ commentList: CommentList) {
        if let encodedCommentList = try? JSONEncoder().encode(commentList) {
            self.userDefaults.set(encodedCommentList, forKey: commentListKey)
        }
    }
    
    func createComment(_ comment: Comment) {
        var commentList = getCommentList()
        commentList.append(comment)
        updateUserDefaults(commentList)
    }
    
    // MARK: - LikedVideo
    func getLikedVideoList() -> [Video] {
        return (getUser()?.likedVideoList) ?? []
    }
    
    func createLikedVideo(_ video: Video) {
        var userList = getUserList()
        let user = getUser()
        let index = userList.firstIndex{ $0.id == getUser()!.id }
        userList[index!] = User(id: user!.id, nickName: user!.nickName, passWord: user!.passWord, likedVideoList: getLikedVideoList() + [video])
        updateUserDefaults(User(id: user!.id, nickName: user!.nickName, passWord: user!.passWord, likedVideoList: getLikedVideoList() + [video]))
        updateUserDefaults(userList)
    }
    
    func deleteLikedVideo(_ video: Video) {
        var likedVideoList = getLikedVideoList()
        var userList = getUserList()
        let user = getUser()
        var index = userList.firstIndex{ $0.id == getUser()!.id }
        likedVideoList.removeAll{ $0.id == video.id }
        userList[index!] = User(id: user!.id, nickName: user!.nickName, passWord: user!.passWord, likedVideoList: likedVideoList)
        updateUserDefaults(User(id: user!.id, nickName: user!.nickName, passWord: user!.passWord, likedVideoList: likedVideoList))
        updateUserDefaults(userList)
    }
    
    func tappedLikedButton(_ video: Video) {
        let likedVideoList = getLikedVideoList()
        if likedVideoList.filter({ $0.id == video.id }).isEmpty {
            createLikedVideo(video)
        } else {
            deleteLikedVideo(video)
        }
    }
}
