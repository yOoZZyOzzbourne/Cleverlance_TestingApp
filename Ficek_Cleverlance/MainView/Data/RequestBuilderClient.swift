//
//  RequestBuilderClient.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 24.02.2023.
//

import Foundation
import Dependencies
import XCTestDynamicOverlay

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
    
    static var testValue = RequestBuilderClient { input in
        return URLRequest(url: input.url)
    }
}
