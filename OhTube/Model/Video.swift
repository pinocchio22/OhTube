//
//  Video.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import Foundation

struct Video: Codable {
    var id: String
    var title: String
    var thumbNail: String
    var channelId: String
    var viewCount: Int
    var uploadDate: String
    var favorite: Bool
    var comment: [Comment]
    
}
