//
//  ImageShowViewModel.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 18.02.2023.
//

import Foundation
import SwiftUI
import Dependencies

protocol ImageShowViewModelType: ObservableObject {
    var imageString: String { get set }
    var imageBase64: Image { get set}
    
    func downloadButtonTapped()
}

final class ImageShowViewModel: ImageShowViewModelType {
    @Dependency(\.downloadImageUseCaseClient) var downloadImageUseCaseClient

    var imageString: String
    @Published var imageBase64: Image
    
    init(imageString: String = "", imageBase64: Image = Image(systemName: "sun.fill")) {
        self.imageString = imageString
        self.imageBase64 = imageBase64
    }
    
    func downloadButtonTapped() {
        Task {
            @MainActor in
            
            do {
                imageBase64 = try downloadImageUseCaseClient.downloadImage(DownloadImageUseCaseClient.Input(imageString: imageString))
            }
            catch {
                print("Request failed")
            }
        }
    }
}

extension ImageShowViewModelType where Self == ImageShowViewModel {
    static var live: Self { Self() }
}
