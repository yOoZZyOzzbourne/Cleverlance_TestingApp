//
//  ImageRepository.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 17.02.2023.
//

import Foundation
import CryptoKit
import Dependencies

extension DependencyValues {
    var imageRepositoryClient: ImageRepositoryClient {
        get { self[ImageRepositoryClient.self] }
        set { self[ImageRepositoryClient.self] = newValue }
    }
}

struct ImageRepositoryClient {
    struct Input {
        let username: String
        let password: String
    }
    let fetchImage: (Input) async throws -> ApiResponse
}

extension ImageRepositoryClient: DependencyKey {
    static var liveValue: ImageRepositoryClient {
        @Dependency(\.requestBuilderClient) var requestBuilderClient

        return Self { input in
                guard let url = URL(string: "https://mobility.cleverlance.com/download/bootcamp/image.php")
                else {
                    throw ResponseError.badUrl
                }
               
            let (data, _) = try await URLSession.shared.data(for: requestBuilderClient.imageRequest(RequestBuilderClient.Input(url: url, username: input.username, password: input.password)))
                
                return try JSONDecoder().decode(ApiResponse.self, from: data)
        }
    }
    
    static var mockValue: ImageRepositoryClient {
        return Self { input in
            return ApiResponse(image: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=")
        }
    }
}



// MARK: - Security client

extension DependencyValues {
    var securityClient: SecurityClient {
        get { self[SecurityClient.self] }
        set { self[SecurityClient.self] = newValue }
    }
}

struct SecurityClient {
    enum SecurityError: Error {
        case dataAreNil
    }

    let sha1: (String) throws -> String
}

extension SecurityClient: DependencyKey {
    static let liveValue = SecurityClient(
        sha1: { input in
            guard let inputData = input.data(using: .utf8) else {
                throw SecurityError.dataAreNil
            }
            let hashed = Insecure.SHA1.hash(data: inputData)
            return hashed.compactMap { String (format: "%02x", $0) }.joined()
        }
    )
}

// MARK: - Request builder client

extension DependencyValues {
    var requestBuilderClient: RequestBuilderClient {
        get { self[RequestBuilderClient.self] }
        set { self[RequestBuilderClient.self] = newValue }
    }
}

struct RequestBuilderClient {
    struct Input {
        let url: URL
        let username: String
        let password: String
    }

    let imageRequest: (Input) throws -> URLRequest
}

extension RequestBuilderClient: DependencyKey {
    static var liveValue: RequestBuilderClient {
        @Dependency(\.securityClient) var securityClient

        return Self(
            imageRequest: { input in
                let sha1String = try securityClient.sha1(input.password.lowercased())

                var request = URLRequest(url: input.url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.addValue(sha1String, forHTTPHeaderField: "authorization")

                var components = URLComponents.init(url: input.url, resolvingAgainstBaseURL: false)
                components?.queryItems = [
                    URLQueryItem(name: "username", value: input.username.lowercased())
                ]
                let query = components?.url?.query
                request.httpBody = query.flatMap { $0.data(using: .utf8) }
                return request
            }
        )
    }
}
