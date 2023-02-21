//
//  FetchImageUseCase.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 19.02.2023.
//

import Foundation
import Dependencies

extension DependencyValues {
    var fetchImageUseCaseClient: FetchImageUseCaseClient {
        get { self[FetchImageUseCaseClient.self] }
        set { self[FetchImageUseCaseClient.self] = newValue }
    }
}

struct FetchImageUseCaseClient {
    struct Input {
        let username: String
        let password: String
    }
    let fetchImage: (Input) async throws -> ApiResponse
}

extension FetchImageUseCaseClient: DependencyKey {
    static var liveValue: FetchImageUseCaseClient {
        @Dependency(\.imageRepositoryClient) var imageRepositoryClient

        return Self(fetchImage: { input in
            return try await imageRepositoryClient.fetchImage(ImageRepositoryClient.Input(username: input.username, password: input.password))
        })
    }
    
    static var mockValue: FetchImageUseCaseClient {
        return Self(fetchImage: { input in
            return ApiResponse(image: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=")
        })
    }
}
