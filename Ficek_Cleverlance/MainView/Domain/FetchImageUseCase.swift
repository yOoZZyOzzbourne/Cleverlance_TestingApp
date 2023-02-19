//
//  FetchImageUseCase.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 19.02.2023.
//

import Foundation
import Combine

protocol FetchImageUseCaseType {
    func fetchImage(username: String, password: String) -> AnyPublisher<ApiResponse, ResponseError>
    var imageRepository: ImageRepositoryType { get }
}

struct FetchImageUseCase: FetchImageUseCaseType {
    var imageRepository: ImageRepositoryType
 
    func fetchImage(username: String, password: String) -> AnyPublisher<ApiResponse, ResponseError> {
        return imageRepository.fetchImage(username: username, password: password)
            .eraseToAnyPublisher()
    }
    
}

extension FetchImageUseCaseType where Self == FetchImageUseCase {
    static var live: Self { Self(imageRepository: .live) }
    static var mock: Self { Self(imageRepository: .mock) }
}
