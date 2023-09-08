//
//  User.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import Foundation

struct User: Codable {
    var id: String
    var nickName: String
    var passWord: String
//    var profileImage: UIImage
    var likedVideoList: [Video] = []
}
