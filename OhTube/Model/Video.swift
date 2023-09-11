//
//  Video.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import Foundation

// MARK: - Welcome

struct RawVideos: Codable {
    let items: [Item]
}

// MARK: - Item

struct Item: Codable {
    let id: String
    let snippet: Snippet
    let statistics: Statistics
}

// MARK: - Snippet

struct Snippet: Codable {
    let publishedAt: String
    let title: String
    let description: String
    let categoryID: String
    let thumbnails: Thumbnails
    let channelTitle: String

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case title, description, thumbnails, channelTitle
        case categoryID = "categoryId"
    }
}

// MARK: - Thumbnails

struct Thumbnails: Codable {
    let thumbnailsDefault, medium, high, standard: Default // 섬네일 사진들

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high, standard
    }
}

// MARK: - Default

struct Default: Codable {
    let url: String // https://i.ytimg.com/vi/43FZXOo6oRM/maxresdefault.jpg (썸네일 사진)
}

// MARK: - Statistics

struct Statistics: Codable {
    let viewCount: String
}

// 데이터 가공 구조체
struct Video: Codable {
    var id: String
    var title: String
    var thumbNail: String
    var description: String
    var channelName: String
    var viewCount: String
    var uploadDate: String
    var favorite: Bool
    var comment: [Comment]?

    var formatViewCount: String {
        var formattedViewCount = ""
        guard let viewCount = Int(viewCount) else { return viewCount }
        if viewCount >= 10000 {
            let roundedValue = round(Double(viewCount) / 10000)
            formattedViewCount = String(format: "%.0f만", roundedValue)
            return formattedViewCount
        } else if viewCount >= 1000 {
            let roundedValue = round(Double(viewCount) / 1000)
            formattedViewCount = String(format: "%.0f천", roundedValue)
            return formattedViewCount
        }
        return ""
    }

    var uploadDateString: String {
        guard let isoDate = ISO8601DateFormatter().date(from: uploadDate) else {
            return ""
        }
        let currentDate = Date()

        let dateGap = Calendar.current.dateComponents([.month, .day, .hour], from: isoDate, to: currentDate)

        if let month = dateGap.month, let day = dateGap.day, let hour = dateGap.hour {
            if month > 0 {
                return "\(month)개월 전"
            } else if day > 0 && day < 28 {
                return "\(day)일 전"
            } else if hour > 0 && hour < 24 {
                return "\(hour)시간 전"
            }
        }
        return "방금 전"
    }
}
