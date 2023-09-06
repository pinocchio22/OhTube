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
    private let commentListKey = "CommentList"
    private let likedVideoListKey = "LikedVideoList"

    typealias UserList = [User]
    typealias CommentList = [Comment]
    typealias LikedVideoList = [Video]
    
    private init() {}
    
    
    // MARK: User
    func getUserList() -> [User] {
        if let encodedUserList = self.userDefaults.object(forKey: Key.userList) as? Data,
           let userList = try? JSONDecoder().decode(UserList.self, from: encodedUserList) {
            return userList
        }
        return []
    }
    
    func saveIslogin() {
        userDefaults.set(true, forKey: Key.isLogin)
    }
    
    private func updateUserDefaults(_ userList: UserList) {
        if let encodedUserList = try? JSONEncoder().encode(userList) {
            self.userDefaults.set(encodedUserList, forKey: Key.userList)
        }
    }
    
    func createUser(_ user: User) {
        var userList = getUserList()
        userList.append(user)
        updateUserDefaults(userList)
    }
    
    // MARK: Comment
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
    
    // MARK: LikedVideo
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
        var likedVideoList = getLikedVideoList()
        likedVideoList.forEach{ item in
            if item.id == video.id {
                deleteLikedVideo(video)
                return
            }
        }
        createLikedVideo(video)
    }
}
