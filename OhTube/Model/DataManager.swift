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
    private let likedVideoListKey = "LikedVideoList"
    
    typealias UserList = [User]
    typealias CommentList = [Comment]
    typealias LikedVideoList = [Video]
    
    private init() {}
    
    // MARK: - User
    private func searchUser(_ id: String) -> User {
        let userList = getUserList()
        for user in userList {
            if user.id == id {
                return User(id: user.id, nickName: user.nickName, passWord: user.passWord)
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
    
    func saveUser(id: String) {
        let user = searchUser(id)
        updateUserDefaults(user)
    }
    
    func saveIslogin(_ state: Bool) {
        userDefaults.set(state, forKey: isLoginKey)
    }
    
    
    // MARK: - UserList
    func getUserList() -> [User] {
        if let encodedUserList = self.userDefaults.object(forKey: Key.userList) as? Data,
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
        if let encodedLikedVideoList = self.userDefaults.object(forKey: likedVideoListKey) as? Data,
           let likedVideoList = try? JSONDecoder().decode(LikedVideoList.self, from: encodedLikedVideoList) {
            return likedVideoList
        }
        return []
    }
    
    private func updateUserDefaults(_ likedVideoList: LikedVideoList) {
        if let encodedLikedVideoList = try? JSONEncoder().encode(likedVideoList) {
            self.userDefaults.set(encodedLikedVideoList, forKey: likedVideoListKey)
        }
    }
    
    func createLikedVideo(_ video: Video) {
        var likedVideoList = getLikedVideoList()
        likedVideoList.append(video)
        updateUserDefaults(likedVideoList)
    }
    
    func deleteLikedVideo(_ video: Video) {
        var likedVideoList = getLikedVideoList()
        for i in 0...likedVideoList.count-1 {
            if likedVideoList[i].id == video.id {
                likedVideoList.remove(at: i)
            }
        }
        updateUserDefaults(likedVideoList)
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
