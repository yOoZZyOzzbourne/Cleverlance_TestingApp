//
//  MockedDownloadImageUseCase.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 19.02.2023.
//

import Foundation
import SwiftUI
import Combine

struct MockedDownloadImageUseCase: DownloadImageUseCaseType {
    func downloadImage(imageString: String) -> Image {
       return Image(systemName: "sun.min")
    }
}

extension DownloadImageUseCaseType where Self == MockedDownloadImageUseCase {
   static var mock: Self { Self() }
}
