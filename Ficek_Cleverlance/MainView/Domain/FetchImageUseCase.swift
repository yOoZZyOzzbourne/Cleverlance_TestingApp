//
//  FetchImageUseCase.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 19.02.2023.
//

import Foundation
import Combine

protocol FetchImageUseCaseType {
    func fetchImageCombine(username: String, password: String) -> AnyPublisher<ApiResponse, ResponseError>
    func fetchImageAsync(username: String, password: String) async throws -> ApiResponse
    var imageRepository: ImageRepositoryType { get }
}

struct FetchImageUseCase: FetchImageUseCaseType {
    
    var imageRepository: ImageRepositoryType
 
    func fetchImageCombine(username: String, password: String) -> AnyPublisher<ApiResponse, ResponseError> {
        return imageRepository.fetchImageCombine(username: username, password: password)
            .eraseToAnyPublisher()
    }
    
    func fetchImageAsync(username: String, password: String) async throws -> ApiResponse {
        return try await imageRepository.fetchImageAsync(username: username, password: password)
    }
    
}

extension FetchImageUseCaseType where Self == FetchImageUseCase {
    static var live: Self { Self(imageRepository: .live) }
    static var mock: Self { Self(imageRepository: .mock) }
}
