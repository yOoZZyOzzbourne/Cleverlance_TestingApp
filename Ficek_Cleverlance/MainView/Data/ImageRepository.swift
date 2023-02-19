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
    func fetchImage(username: String, password: String) -> AnyPublisher<ApiResponse, ResponseError>
}

struct ImageRepository: ImageRepositoryType {
    func fetchImage(username: String, password: String) -> AnyPublisher<ApiResponse, ResponseError> {
        guard let url = URL(string: "https://mobility.cleverlance.com/download/bootcamp/image.php")
        else {
            return Fail(error: .badUrl)
                .eraseToAnyPublisher()
        }
        
        let inputData = username.lowercased().data(using: .utf8)
        let hashed = Insecure.SHA1.hash(data: inputData!)
        let hashedUsername = hashed.compactMap { String(format: "%02x", $0) }.joined()
         
        return Just(username)
            .encode(encoder: JSONEncoder())
        //            .mapError { _ in
        //                ResponseError.badUrl
        //            }
            .map { data -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.addValue(hashedUsername, forHTTPHeaderField: "authorization")
                
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                
                components.queryItems = [
                    URLQueryItem(name: "username", value: password.lowercased()),
                ]
                let query = components.url!.query
                
                request.httpBody = Data(query!.utf8)
                
                return request
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
}

extension ImageRepositoryType where Self == ImageRepository {
    static var live: Self { Self() }
}
