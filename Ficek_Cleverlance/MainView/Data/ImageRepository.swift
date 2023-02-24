//
//  ImageRepository.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 17.02.2023.
//

import Foundation
import CryptoKit
import Dependencies
import XCTestDynamicOverlay

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
        @Dependency(\.apiClient) var apiClient
        @Dependency(\.requestBuilderClient) var requestBuilderClient
        
        return Self(
            fetchImage: { input in
                guard let url = URL(string: "https://mobility.cleverlance.com/download/bootcamp/image.php") else {
                    throw ResponseError.badUrl
                }
                
                let request = try requestBuilderClient.imageRequest(
                    RequestBuilderClient.Input(
                        url: url,
                        username: input.username,
                        password: input.password
                    )
                )
                
                let (data, _) = try await apiClient.request(request)
                
                return try JSONDecoder().decode(ApiResponse.self, from: data)
            }
        )
    }
}

extension ImageRepositoryClient {
    static func mock() -> ImageRepositoryClient {
        return ImageRepositoryClient(
            fetchImage: { _ in
                return ApiResponse(image: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=")
            }
        )
    }
}
