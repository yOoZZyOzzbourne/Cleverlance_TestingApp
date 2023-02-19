//
//  MockedImageRepository.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 19.02.2023.
//

import Foundation
import Combine


struct MockedImageRepository: ImageRepositoryType {
    func fetchImage(username: String, password: String) -> AnyPublisher<ApiResponse, ResponseError> {
        return Just(ApiResponse(image: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="))
            .mapError { error in
                ResponseError.internalError
            }
            .eraseToAnyPublisher()
    }
}

extension ImageRepositoryType where Self == MockedImageRepository {
    static var mock: Self { Self() }
}
