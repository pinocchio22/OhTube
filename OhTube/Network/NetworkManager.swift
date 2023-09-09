//
//  NetworkManager.swift
//  OhTube
//
//  Created by 박성원 on 2023/09/05.
//

import Foundation


//MARK: - 에러 정의

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

final class NetworkManager {
    
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    //타입 별명 (치환)
    typealias NetworkCompletion = (Result<[Video], NetworkError>) -> Void
    
    
    // 카테고리별 (일반적)네트워킹 요청하는 함수
    func fetchVideo(category: String,maxResult: Int ,completion: @escaping NetworkCompletion) {
        let urlString = "\(YouTubeAPI.requestUrl)\(YouTubeAPI.reQuestInfo)&\(YouTubeAPI.chart)&\(YouTubeAPI.apiKey)&\(YouTubeAPI.maxResults)\(maxResult)&\(category)&\(YouTubeAPI.regionCode)"
        
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
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
            let video = try decoder.decode(welcome.self, from: data)
            return videoforEach(video: video)
            // 실패
        } catch DecodingError.dataCorrupted(_) {
            return nil
        } catch DecodingError.keyNotFound(_, _) {
            return nil
        } catch DecodingError.valueNotFound(_, _) {
            return nil
        } catch DecodingError.typeMismatch(_, _)  {
            return nil
        } catch {
            return nil
        }
    }
    
    private func videoforEach(video: welcome) -> [Video] {
        var youtubeArray: [Video] = []
        video.items.forEach { result in
            youtubeArray.append(Video(id: result.id, title: result.snippet.title, thumbNail: result.snippet.thumbnails.high.url, description: result.snippet.description, channelId: result.snippet.channelTitle, viewCount: result.statistics.viewCount, uploadDate: result.snippet.publishedAt, favorite: false))
        }
        return youtubeArray
    }

   
}
