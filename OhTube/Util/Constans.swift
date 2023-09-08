//
//  Constans.swift
//  OhTube
//
//  Created by playhong on 2023/09/04.
//

import UIKit

enum Font {
    static let menuTitleFont = UIFont.boldSystemFont(ofSize: 30)
    static let mainTitleFont = UIFont.boldSystemFont(ofSize: 24)
    static let contentFont = UIFont.systemFont(ofSize: 16)
    static let descriptionFont = UIFont.systemFont(ofSize: 10)
    static let commentFont = UIFont.systemFont(ofSize: 12)
}

enum Margin {
    static let defaultPadding: Int = 20
    static let spacing: Int = 10
}

enum Message {
    static let toast = """
                                아이디와 비밀번호가
                                일치하지 않습니다.
                                """
}













public enum YouTubeAPI {
    static let requestUrl = "https://youtube.googleapis.com/youtube/v3/videos?"
    static let reQuestInfo = "part=snippet%2Cstatistics"
    static let chart = "chart=mostPopular"
//    static let apiKey = "key=AIzaSyB4mgZGx7am_zDKQr4I75nerrwG0KFZVeE"
//    static let apiKey = "key=AIzaSyBeu_eK6eaWUr6yzpu_Ir7xozpS02rqHAw"
    static let apiKey = "key=AIzaSyDZj6Feg2H_noeQuKgvILQYuKfTG1nnGAM"
    static let maxResults = "maxResults=5"
    static let regionCode = "regionCode=KR"
}

public enum YouTubeApiVideoCategoryId {
    static let sport = "videoCategoryId=17"
    static let filmAndAnimation = "videoCategoryId=1"
    static let music = "videoCategoryId=" //"videoCategoryId=10"
    static let comedy = "videoCategoryId=23"
    static let entertainment = "videoCategoryId=24"
    static let gaming = "videoCategoryId=20"
}

public enum searchYouTubeAPI {
    static let requestUrl = "https://youtube.googleapis.com/youtube/v3/search?"
    static let reQuestInfo = "part=snippet"
    static let apiKey = "key=AIzaSyBeu_eK6eaWUr6yzpu_Ir7xozpS02rqHAw"
    static let maxResults = "maxResults=5"
    static let regionCode = "regionCode=KR"
    static let resultOrder = "order=viewCount"
}

public struct Cell {
    static let mainViewIdentifier: String = "MainCollectionViewCell"
}

//일반 URL
//https://youtube.googleapis.com/youtube/v3/videos?
//part=snippet%2Cstatistics
//&
//chart=mostPopular
//&
//key=AIzaSyB4mgZGx7am_zDKQr4I75nerrwG0KFZVeE
//&
//maxResults=50
//&
//regionCode=KR
//&
//videoCategoryId=17


// 검색 URL
//https://youtube.googleapis.com/youtube/v3/search?
//part=snippet
//&
//key=AIzaSyB4mgZGx7am_zDKQr4I75nerrwG0KFZVeE
//&
//maxResults=10
//&
//regionCode=KR
//&
//q=%22BTS%22
//&
//order=viewCount
