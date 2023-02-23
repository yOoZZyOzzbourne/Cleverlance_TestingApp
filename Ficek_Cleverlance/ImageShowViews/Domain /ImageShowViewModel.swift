//
//  ImageShowViewModel.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 18.02.2023.
//

import Foundation
import SwiftUI
import Dependencies

final class ImageShowViewModel: ObservableObject {
    @Dependency(\.downloadImageUseCaseClient) var downloadImageUseCaseClient
    
    @Published var imageBase64: Image
    var imageString: String
    
    init(
        imageString: String = "",
        imageBase64: Image = Image(systemName: "sun.fill")
    ) {
        self.imageString = imageString
        self.imageBase64 = imageBase64
    }
    
    func downloadButtonTapped() {
        Task {
            @MainActor in
            
            do {
                imageBase64 = try downloadImageUseCaseClient.downloadImage(
                    DownloadImageUseCaseClient.Input(
                        imageString: imageString
                    )
                )
            }
            catch {
                print("Request failed")
            }
        }
    }
}
