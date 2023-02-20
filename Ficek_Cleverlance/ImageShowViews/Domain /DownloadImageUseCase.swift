//
//  DownloadImageUseCase.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 19.02.2023.
//

import Foundation
import SwiftUI
import Combine

protocol DownloadImageUseCaseType {
    func downloadImage(imageString: String) -> Image
}

struct DownloadImageUseCase: DownloadImageUseCaseType {
    func downloadImage(imageString: String) -> Image {
        guard let stringData = Data(base64Encoded: imageString),
              let uiImage = UIImage(data: stringData) else {
            print("Error: couldn't create UIImage")
                return Image(systemName: "")}
        
        return Image(uiImage: uiImage)
    }
}

extension DownloadImageUseCaseType where Self == DownloadImageUseCase {
    static var live: Self { Self() }
}

