//
//  NetworkManager.swift
//  OhTube
//
//  Created by 박성원 on 2023/09/05.
//

import Foundation
import Alamofire

// MARK: - 에러 정의

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

final class NetworkManager {
    // 여러화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듦
    static let shared = NetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    //타입 별명 : 타입이 길 때 사용 -> 수학 개념에서 치환느낌 (이 타입을 NetworkCompletion이라는 별명으로 사용할거야)
    typealias NetworkCompletion = (Result<[Video], NetworkError>) -> Void
    
    // 네트워킹 요청하는 함수
    func fetchVideo(category: String, maxResult: Int, completion: @escaping NetworkCompletion) {
        let urlString = "\(YouTubeAPI.requestUrl)\(YouTubeAPI.reQuestInfo)&\(YouTubeAPI.chart)&\(Secret.apiKey)&\(YouTubeAPI.maxResults)\(maxResult)&\(category)&\(YouTubeAPI.regionCode)"
        
        //        performRequest(with: String) { <#Result<[Music], NetworkError>#> in -> Result타입을 써서 콜백함수를 실행하게 만듬 (nil이 나와 오류가 날 수 있기 때문에)
        //            <#code#>
        //        }
        performRequest(with: urlString) { result in
            completion(result) //fetchVideo함수의 매개변수클로저completion
            
        }
    }
    
    // 실제 Request하는 함수 (비동기적 실행 ===> 클로저 방식으로 끝난 시점을 전달 받도록 설계)
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        
        //비동기적 코드 -> 2번쓰레드에서 completion실행
        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 결과를 받음
            if let videos = self.parseJSON(safeData) {
                completion(.success(videos))
            } else {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아본 데이터 분석하는 함수 (동기적 실행)
    private func parseJSON(_ data: Data) -> [Video]? {
        // 성공
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let video = try decoder.decode(RawVideos.self, from: data)
            return videoforEach(video: video)
            // 실패 (어디가 틀린 건지 알 수 있음)
        } catch DecodingError.dataCorrupted(let context) {
               print("Data corrupted: \(context.debugDescription)")
           } catch DecodingError.keyNotFound(let key, let context) {
               print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
           } catch DecodingError.valueNotFound(let type, let context) {
               print("Value of type '\(type)' not found: \(context.debugDescription)")
           } catch DecodingError.typeMismatch(let type, let context) {
               print("Type mismatch for type '\(type)' : \(context.debugDescription)")
           } catch {
               print("Decoding error: \(error.localizedDescription)")
           }
        return nil
    }
    
    private func videoforEach(video: RawVideos) -> [Video] {
        var youtubeArray: [Video] = []
        video.items.forEach { result in
            youtubeArray.append(Video(id: result.id, title: result.snippet.title, thumbNail: result.snippet.thumbnails.high.url, description: result.snippet.description, channelName: result.snippet.channelTitle, viewCount: result.statistics.viewCount, uploadDate: result.snippet.publishedAt, favorite: false))
        }
        return youtubeArray
    }
}
