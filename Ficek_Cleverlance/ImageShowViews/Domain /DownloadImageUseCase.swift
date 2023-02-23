//
//  DownloadImageUseCase.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 19.02.2023.
//

import Foundation
import SwiftUI
import Dependencies
import XCTestDynamicOverlay

extension DependencyValues {
    var downloadImageUseCaseClient: DownloadImageUseCaseClient {
        get { self[DownloadImageUseCaseClient.self] }
        set { self[DownloadImageUseCaseClient.self] = newValue }
    }
}

struct DownloadImageUseCaseClient {
    struct Input {
        let imageString: String
    }
    
    let downloadImage: (Input) throws -> Image
}

extension DownloadImageUseCaseClient: DependencyKey {
    static var liveValue: DownloadImageUseCaseClient {
        
        return Self(downloadImage: { input in
            guard let stringData = Data(base64Encoded: input.imageString),
                  let uiImage = UIImage(data: stringData) else {
                print("Error: couldn't create UIImage")
                return Image(systemName: "")}
            
            return Image(uiImage: uiImage)
        })
    }
    
    static let testValue = DownloadImageUseCaseClient(
        downloadImage: unimplemented("DownloadImageUseCaseClient(downloadImage: )")
    )
    
    static let previewValue = DownloadImageUseCaseClient(
        downloadImage: { _ in
            return Image(systemName: "sun.min")
        }
    )
}

extension DownloadImageUseCaseClient {
    static func mock() -> DownloadImageUseCaseClient {
        return DownloadImageUseCaseClient( downloadImage: { _ in
            return Image(systemName: "sun.min")
        }
        )
    }
}


