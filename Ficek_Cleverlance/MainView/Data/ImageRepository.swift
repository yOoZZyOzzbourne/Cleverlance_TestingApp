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
        
        let inputData = Data(username.lowercased().utf8)
        var hashedUsername = Insecure.SHA1.hash(data: inputData).description
        hashedUsername.removeFirst(13)
        
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
                error as? ResponseError ?? .inetrnalError
            }
            .eraseToAnyPublisher()
    }
}

extension ImageRepositoryType where Self == ImageRepository {
    static var live: Self { Self() }
}
