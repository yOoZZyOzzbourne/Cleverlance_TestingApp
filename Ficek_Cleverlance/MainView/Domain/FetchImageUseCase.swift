//
//  FetchImageUseCase.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 19.02.2023.
//

import Foundation
import Dependencies

extension DependencyValues {
    var fetchImageUseCaseClient: FetchImageUseCase {
        get { self[FetchImageUseCase.self] }
        set { self[FetchImageUseCase.self] = newValue }
    }
}

struct FetchImageUseCase {
    struct Input {
        let username: String
        let password: String
    }
    let fetchImage: (Input) async throws -> ApiResponse
}

extension FetchImageUseCase: DependencyKey {
    static var liveValue: FetchImageUseCase {
        @Dependency(\.imageRepositoryClient) var imageRepositoryClient

        return Self(
            fetchImage: { input in
                try await imageRepositoryClient.fetchImage(
                    ImageRepositoryClient.Input(
                        username: input.username,
                        password: input.password
                    )
                )
            }
        )
    }
}

extension FetchImageUseCase {
    static func mock() -> FetchImageUseCase {
        return FetchImageUseCase(
            fetchImage: { _ in
                return ApiResponse(image: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=")
            }
        )
    }
}
