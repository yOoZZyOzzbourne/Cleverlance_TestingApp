//
//  ImageRepository.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 17.02.2023.
//

import Foundation
import Combine
import CryptoKit

protocol ImageRepositoryType {
    func fetchImageCombine(username: String, password: String) -> AnyPublisher<ApiResponse, ResponseError>
    func fetchImageAsync(username: String, password: String) async throws -> ApiResponse
}

struct ImageRepository: ImageRepositoryType {
   
    func fetchImageCombine(username: String, password: String) -> AnyPublisher<ApiResponse, ResponseError> {
        guard let url = URL(string: "https://mobility.cleverlance.com/download/bootcamp/image.php")
        else {
            return Fail(error: .badUrl)
                .eraseToAnyPublisher()
        }
         
        return Just(username)
            .encode(encoder: JSONEncoder())
            .map { data -> URLRequest in
                return requestBuilder(url: url, username: username, password: password)
            }
            .flatMap {
                URLSession.shared.dataTaskPublisher(for: $0)
                    .map(\.data)
                    .decode(type: ApiResponse.self, decoder: JSONDecoder())
            }
            .mapError { error -> ResponseError in
                error as? ResponseError ?? .internalError
            }
            .eraseToAnyPublisher()
    }
    
    func fetchImageAsync(username: String, password: String) async throws -> ApiResponse {
        guard let url = URL(string: "https://mobility.cleverlance.com/download/bootcamp/image.php")
        else {
            throw ResponseError.badUrl
        }
        
        let (data, _) = try await URLSession.shared.data(for: requestBuilder(url: url, username: username, password: password))
        
        return try JSONDecoder().decode(ApiResponse.self, from: data)
    }
    
    func hashMyPassword(password: String) -> String {
        let inputData = password.lowercased().data(using: .utf8)
        let hashed = Insecure.SHA1.hash(data: inputData!)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func requestBuilder(url: URL, username: String, password: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(hashMyPassword(password: password), forHTTPHeaderField: "authorization")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        components.queryItems = [
            URLQueryItem(name: "username", value: username.lowercased()),
        ]
        let query = components.url!.query
        
        request.httpBody = Data(query!.utf8)
        return request
    }
}

extension ImageRepositoryType where Self == ImageRepository {
    static var live: Self { Self() }
}
