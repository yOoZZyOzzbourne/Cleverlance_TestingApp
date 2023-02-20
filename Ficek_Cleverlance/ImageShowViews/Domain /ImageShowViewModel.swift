//
//  ImageShowViewModel.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 18.02.2023.
//

import Foundation
import Combine
import SwiftUI

protocol ImageShowViewModelType: ObservableObject {
    var imageString: String { get set }
    var imageBase64: Image { get set}
    
    func downloadButtonTapped()
}

final class ImageShowViewModel: ImageShowViewModelType {
    let downloadImageUseCase: DownloadImageUseCaseType
    var imageString: String
    @Published var imageBase64: Image
    
    init(imageString: String = "", imageBase64: Image = Image(systemName: "sun.fill"), downloadImageUseCase: DownloadImageUseCaseType) {
        self.imageString = imageString
        self.imageBase64 = imageBase64
        self.downloadImageUseCase = downloadImageUseCase
    }
    
    func downloadButtonTapped() {
       imageBase64 = downloadImageUseCase.downloadImage(imageString: imageString)
    }
}

extension ImageShowViewModelType where Self == ImageShowViewModel {
    static var live: Self { Self(downloadImageUseCase: .live) }
}
