//
//  Comment.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import Foundation

struct Comment: Codable {
    var nickName: String
    var content: String
    var date: String
    var videoId: String
    var userId: String
}
