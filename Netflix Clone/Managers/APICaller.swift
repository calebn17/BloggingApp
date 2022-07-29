//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 5/2/22.
//

import Foundation

struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    //static let YoutubeAPI_KEY = "AIzaSyBQgbMvoYGSgtCBDqwxOy_Sp_DfHHN9CKI"
    //my personal key
    static let YoutubeAPI_KEY = "AIzaSyCe97cNur1TdzIfoRzkBo1ihJzLIr_hjW8"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedTogetData
}

final class APICaller {
    
    static let shared = APICaller()
    private init() {}
    
    func getTrendingMovies() async throws -> [Title] {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return []}
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
        let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
        return result.results
    }
    
    func getTrendingTV() async throws -> [Title] {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return []}
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
        let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
        return result.results
    }
    
    func getUpcomingMovies() async throws -> [Title] {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else {return []}
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
        let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
        return result.results
    }
    
    func getPopular() async throws -> [Title] {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)") else {return []}
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
        let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
        return result.results
    }
    
    func getTopRated() async throws -> [Title] {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)") else {return []}
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
        let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
        return result.results
    }
    
    func getDiscoverMovies() async throws -> [Title] {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&page=1&with_watch_monetization_types=flatrate") else {return []}
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
        let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
        return result.results
    }
    
    func search(with query: String) async throws -> [Title] {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return []}
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {return []}
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(TitlesResponse.self, from: data)
        return response.results
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                //let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))

            }
            catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String) async throws -> VideoElement? {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return nil}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return nil}
        let request = URLRequest(url: url)
        let (data, _ ) = try await URLSession.shared.data(for: request, delegate: nil)
        let result = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
        return result.items[0]
        
    }
    
//MARK: - Private Methods
    enum HTTPMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
//    ///Reusable function for making API requests. Returns a URL Request
//    private func createRequest(with url: URL?, token type: HTTPMethod) async throws -> URLRequest? {
//        guard let apiURL = url else {
//            return nil
//        }
//        var request = URLRequest(url: apiURL)
//        request.setValue(
//            "Bearer \(K.bearerToken)",
//            forHTTPHeaderField: "Authorization"
//        )
//        request.httpMethod = type.rawValue
//        request.timeoutInterval = 60
//        return request
//    }
    
}
