//
//  Constans.swift
//  OhTube
//
//  Created by playhong on 2023/09/04.
//

import UIKit

public enum Font {
    static let menuTitleFont = UIFont.boldSystemFont(ofSize: 30)
    static let mainTitleFont = UIFont.boldSystemFont(ofSize: 24)
    static let contentFont = UIFont.systemFont(ofSize: 16)
    static let descriptionFont = UIFont.systemFont(ofSize: 10)
    static let commentFont = UIFont.boldSystemFont(ofSize: 12)
}

public enum Margin {
    static let defaultPadding: Int = 20
    static let spacing: Int = 10
}

public enum Message {
    static let toast = """
    아이디와 비밀번호가
    일치하지 않습니다.
    """
}

public enum RegistraionForm {
    static let idRegex = "[A-Za-z0-9]{4,20}"
    static let passWordRegex = "(?=.*[a-zA-Z])(?=.*\\d)(?=.*[$@$!%*?&#^().,])[A-Za-z\\d$@$!%*?&#^().,]{8,16}"
}

public enum YouTubeAPI {
    static let requestUrl = "https://youtube.googleapis.com/youtube/v3/videos?"
    static let reQuestInfo = "part=snippet%2Cstatistics"
    static let chart = "chart=mostPopular"
    static let maxResults = "maxResults="
    static let regionCode = "regionCode=KR"
}

public enum YouTubeApiVideoCategoryId {
    static let sport = "&videoCategoryId=17"
    static let filmAndAnimation = "&videoCategoryId=1"
    static let music = "&videoCategoryId=10"
    static let comedy = "&videoCategoryId=23"
    static let entertainment = "&videoCategoryId=24"
    static let gaming = "&videoCategoryId=20"
    static let all = ""
}

public enum searchYouTubeAPI {
    static let requestUrl = "https://youtube.googleapis.com/youtube/v3/search?"
    static let reQuestInfo = "part=snippet"
    static let apiKey = "key=AIzaSyBeu_eK6eaWUr6yzpu_Ir7xozpS02rqHAw"
    static let maxResults = "maxResults=5"
    static let regionCode = "regionCode=KR"
    static let resultOrder = "order=viewCount"
}

public enum Cell {
    static let mainViewIdentifier: String = "MainCollectionViewCell"
    static let mainViewCategoryIdentifier: String = "MainViewCategoryCollectionViewCell"
}
